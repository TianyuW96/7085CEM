import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import gpflow
from DGP.model import RegressionModel
from scipy.stats import norm, skew
from sklearn.metrics import mean_squared_error
from scipy.special import boxcox1p
import argparse

parser = argparse.ArgumentParser(description='GP for regression', epilog='#' * 75)
parser.add_argument('--num_inducing', type=int, default=128, help='number of inducing points. Default: 128')
parser.add_argument('--layers', default=5, type=int, help='the number of DGP layers, Default: 5')
parser.add_argument('--model', default='dgp', type=str, help='select model for regression, Default: gp')
parser.add_argument('--lr', default =[0.005, 0.0001, 0.0025], type=int,help='learning rate')
parser.add_argument('--max_iter', default = 300, type=int,  help='max_iteration')
parser.add_argument('--samples', default = 20, type=int,  help='n_posterior_samples')
args = parser.parse_args()


def _preprocess():
    df_train = pd.read_csv('train.csv')
    df_test = pd.read_csv('test.csv')

    ID_df_train = df_train['Id']
    ID_df_test = df_test['Id']

    #################Drop Id column which is not useful for regression#####################
    df_train.drop("Id", axis=1, inplace=True)
    df_test.drop("Id", axis=1, inplace=True)

    ##############  Deleting outliers of GrLivArea ######################
    # fig, ax = plt.subplots()
    # ax.scatter(x = df_train['GrLivArea'], y = df_train['SalePrice'])  # GrLivArea: 地上居住面积平方英尺
    # plt.ylabel('SalePrice', fontsize=13)
    # plt.xlabel('GrLivArea', fontsize=13)
    # plt.draw()
    # plt.pause(1)
    df_train = df_train.drop(df_train[(df_train['GrLivArea'] > 4000) | (df_train['SalePrice'] > 700000)].index)
    # fig, ax = plt.subplots()
    # ax.scatter(df_train['GrLivArea'], df_train['SalePrice'])
    # plt.ylabel('SalePrice', fontsize=13)
    # plt.xlabel('GrLivArea', fontsize=13)
    # plt.draw()
    # plt.pause(1)
    ##############  Deleting outliers of TotalBsmtSF ######################
    # fig, ax = plt.subplots()
    # ax.scatter(x=df_train['TotalBsmtSF'], y=df_train['SalePrice'])
    # plt.ylabel('SalePrice', fontsize=13)
    # plt.xlabel('TotalBsmtSF', fontsize=13)
    # plt.draw()
    # plt.pause(1)
    df_train = df_train.drop(df_train[(df_train['TotalBsmtSF'] > 3000)].index)
    # fig, ax = plt.subplots()
    # ax.scatter(df_train['TotalBsmtSF'], df_train['SalePrice'])
    # plt.ylabel('SalePrice', fontsize=13)
    # plt.xlabel('TotalBsmtSF', fontsize=13)
    # plt.draw()
    # plt.pause(1)

    ntrain = df_train.shape[0]

    #################transform this variable and make it more normally distributed###########
    df_train["SalePrice"] = np.log1p(df_train["SalePrice"])


    #####################  merge train and test data to do feature engineering together######
    y_train = df_train.SalePrice.values
    merge_data = pd.concat((df_train, df_test)).reset_index(drop=True)
    merge_data.drop(['SalePrice'], axis=1, inplace=True)


#######################  deal with the missing values ########################

    #######For all these categorical features, we fill the missing value with None##########
    cols = ('PoolQC','MiscFeature','Alley','Fence','FireplaceQu','GarageType','GarageFinish',
            'GarageQual','GarageCond','BsmtQual','BsmtCond','BsmtExposure','BsmtFinType1',
            'BsmtFinType2','MasVnrType','MSSubClass')
    for col in cols:
        merge_data[col] = merge_data[col].fillna('None')

    #######For all these numerical features, we fill the missing value with 0##########
    cols = ('GarageYrBlt', 'GarageArea','GarageCars','BsmtFinSF1','BsmtFinSF2',
            'BsmtUnfSF', 'TotalBsmtSF', 'BsmtFullBath', 'BsmtHalfBath','MasVnrArea')
    for col in cols:
        merge_data[col] = merge_data[col].fillna(0)

    #######For all these numerical features, we fill the missing value with most common value#####
    cols = ('MSZoning','Electrical','KitchenQual','Exterior1st','Exterior2nd','SaleType')
    for col in cols:
        merge_data[col] = merge_data[col].fillna(merge_data[col].mode()[0])

    #######For these features, we deal them indivisually######################
    merge_data = merge_data.drop(['Utilities'], axis=1)
    merge_data["Functional"] = merge_data["Functional"].fillna("Typ")
    merge_data["LotFrontage"] = merge_data.groupby("Neighborhood")["LotFrontage"].transform(
        lambda x: x.fillna(x.median()))

    #######For these  features, we change them into category then For numerical variables,
    ######## we need check and deal with their skewness.######################
    cols = ('MSSubClass', 'OverallCond', 'YrSold', 'MoSold')
    for col in cols:
        merge_data[col] = merge_data[col].apply(str)
    numeric_feats = merge_data.dtypes[merge_data.dtypes != "object"].index
    skewed_feats = merge_data[numeric_feats].apply(lambda x: skew(x.dropna())).sort_values(ascending=False)
    skewness = pd.DataFrame({'Skew': skewed_feats})
    skewness = skewness[abs(skewness) > 0.75]
    skewed_features = skewness.index
    lam = 0.15
    for feat in skewed_features:
        merge_data[feat] = boxcox1p(merge_data[feat], lam)

##############################One Hot Encoding for Category Features###################
    cols = ('FireplaceQu', 'BsmtQual', 'BsmtCond', 'GarageQual', 'GarageCond',
        'ExterQual', 'ExterCond','HeatingQC', 'PoolQC', 'KitchenQual', 'BsmtFinType1',
        'BsmtFinType2', 'Functional', 'Fence', 'BsmtExposure', 'GarageFinish', 'LandSlope',
        'LotShape', 'PavedDrive', 'Street', 'Alley', 'CentralAir', 'MSSubClass', 'OverallCond',
        'YrSold', 'MoSold','BldgType','Condition1','Condition2','Electrical','Exterior1st','Exterior2nd',
        'Foundation','GarageType','Heating','HouseStyle','LandContour','LotConfig','MSZoning','MasVnrType',
        'MiscFeature','Neighborhood','RoofMatl','RoofStyle','SaleCondition','SaleType','YearBuilt','YearRemodAdd')
    for col in cols:
        OnehotEn = pd.get_dummies(merge_data[col],prefix = col)
        merge_data.drop([col], axis=1, inplace=True)
        merge_data = pd.concat([merge_data,OnehotEn],axis=1)

    merge_data['TotalSF'] = merge_data['TotalBsmtSF'] + merge_data['1stFlrSF'] + merge_data['2ndFlrSF']
    train = merge_data[:ntrain]
    test = merge_data[ntrain:]

    return train,y_train,test,ID_df_test

def rmsle(y, y_pred):
    return np.sqrt(mean_squared_error(y, y_pred))

def GP(train,y_train,test):
    train = train.values
    y_train = y_train.reshape((-1, 1))
    k = gpflow.kernels.SquaredExponential(input_dim=train.shape[1], variance=1.0)
    model_gp = gpflow.models.GPR(train, y_train, kern=k)
    model_gp.likelihood.variance = 0.0
    gpflow.train.ScipyOptimizer().minimize(model_gp)
    gp_train_pred, var = model_gp.predict_y(train)
    gp_test_pred, var = model_gp.predict_y(test.values)
    gp_pred = np.expm1(gp_test_pred)
    print("gp_train_error = ", rmsle(y_train, gp_train_pred))
    return gp_pred

def DGP(train,y_train,test,args):
    train = train.values
    y_train = y_train.reshape((-1, 1))
    model = RegressionModel(lr = args.lr, max_iterations = args.max_iter, n_layers = args.layers, num_inducing = args.num_inducing
                            ,n_posterior_samples=args.samples)
    model.fit(train, y_train, test.values, [], [])
    dgp_test_pred, v = model.predict(test.values)
    dgp_train_pred, v = model.predict(train)
    dgp_pred = np.expm1(dgp_test_pred)
    print("dgp_train_error = ", rmsle(y_train, dgp_train_pred))
    return dgp_pred

def main():
    train, y_train, test ,ID_df_test = _preprocess()
    if args.model == 'gp':             ####### Running Gaussian Process#######
        pred = GP(train, y_train,test)
        ans = pd.DataFrame()
        ans['Id'] = ID_df_test
        ans['SalePrice'] = pred
        ans.to_csv('submission_gp.csv', index=False)
        #####Public Score is 0.16258 ###########
    else:
        pred = DGP(train,y_train,test,args)  ####### Running Deep Gaussian Process#######
        ans = pd.DataFrame()
        ans['Id'] = ID_df_test
        ans['SalePrice'] = pred
        ans.to_csv('submission_dgp.csv', index=False)
        #####Public Score is 0.24197 ###########

if __name__ == '__main__':
    main()