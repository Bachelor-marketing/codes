# Copyright (c) Meta Platforms, Inc. and its affiliates.

# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

#############################################################################################
####################         Facebook MMM Open Source - Robyn 3.6.2    ######################
####################                    Quick guide                   #######################
#############################################################################################

################################################################
#### Step 0: Setup environment

## Install, load, and check (latest) version
install.packages("remotes") # Install remotes first if you haven't already
remotes::install_github("facebookexperimental/Robyn/R")
library(Robyn) 

# Please, check if you have installed the latest version before running this demo. Update if not
# https://github.com/facebookexperimental/Robyn/blob/main/R/DESCRIPTION#L4
packageVersion("Robyn")

## Force multicore when using RStudio
Sys.setenv(R_FUTURE_FORK_ENABLE="true")
options(future.fork.enable = TRUE)

#Sys.setenv(R_FUTURE_FORK_ENABLE="false")
#options(future.fork.enable = FALSE)

## Must install the python library Nevergrad once
## ATTENTION: The latest Python 3.10 version may cause Nevergrad installation error
## See here for more info about installing Python packages via reticulate
## https://rstudio.github.io/reticulate/articles/python_packages.html

install.packages("reticulate") # Install reticulate first if you haven't already
library("reticulate") # Load the library

## Option 1: nevergrad installation via PIP (no additional installs)
virtualenv_create("r-reticulate")
use_virtualenv("r-reticulate", required = TRUE)
py_install("nevergrad", pip = TRUE)
py_config() # Check your python version and configurations
## In case nevergrad still can't be installed,
# Sys.setenv(RETICULATE_PYTHON = "~/.virtualenvs/r-reticulate/bin/python")
# Reset your R session and re-install Nevergrad with option 1

## Option 2: nevergrad installation via conda (must have conda installed)
# conda_create("r-reticulate", "Python 3.9") # Only works with <= Python 3.9 sofar
# use_condaenv("r-reticulate")
# conda_install("r-reticulate", "nevergrad", pip=TRUE)
# py_config() # Check your python version and configurations
## In case nevergrad still can't be installed,
## please locate your python file and run this line with your path:
# use_python("~/Library/r-miniconda/envs/r-reticulate/bin/python3.9")
# Alternatively, force Python path for reticulate with this:
# Sys.setenv(RETICULATE_PYTHON = "~/Library/r-miniconda/envs/r-reticulate/bin/python3.9")
# Finally, reset your R session and re-install Nevergrad with option 2

# Check this issue for more ideas to debug your reticulate/nevergrad issues:
# https://github.com/facebookexperimental/Robyn/issues/189

################################################################
#### Step 1: Load data

## Check simulated dataset or load your own dataset
#data("dt_simulated_weekly")
#head(dt_simulated_weekly)

batch_path = file.choose()
#batch.csvを読み込む
batch_data <- read.csv(batch_path)
head(batch_data)
## Check holidays from Prophet
# 59 countries included. If your country is not included, please manually add it.
# Tipp: any events can be added into this table, school break, events etc.
#data("dt_prophet_holidays")
#head(dt_prophet_holidays)

holiday_path = file.choose()
#batch.csvを読み込む
holiday_data <- read.csv(holiday_path)
head(holiday_data)
## Set robyn_object. It must have extension .RDS. The object name can be different than Robyn:
robyn_object <- "~/batchelor/MyRobyn.RDS"

################################################################
#### Step 2a: For first time user: Model specification in 4 steps

#### 2a-1: First, specify input variables

## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
## All sign control are now automatically provided: "positive" for media & organic variables
## and "default" for all others. User can still customise signs if necessary. Documentation
## is available in ?robyn_inputs
## ------------------------------------------------------------------------------------------ ##
#' InputCollect <- robyn_inputs(
#'   dt_input = batch_data
#'   ,dt_holidays = holiday_data
#'   ,date_var = "DATE" # date format must be "2020-01-01"(YYYY-MM-DD)
#'   ,dep_var = "Conversion_3_male_Tokyo" # there should be only one dependent variable
#'   ,dep_var_type = "conversion" # "revenue" or "conversion"
#'   ,prophet_vars = c("trend", "season", "weekday" ,"holiday") # "trend","season", "weekday" & "holiday"
#'   ,prophet_country = "JP"# input one country. dt_prophet_holidays includes 59 countries by default
#'   #,context_vars = c("competitor_sales_B", "events") # e.g. competitors, discount, unemployment etc
#'   ,context_vars = c('boolean_value_1','boolean_value_3','boolean_value_4','boolean_value_5','boolean_value_6','boolean_value_7','boolean_value_8','boolean_value_10','boolean_value_14','boolean_value_16','boolean_value_19')
#'   
#'   #,paid_media_spends = 
#' #year data
#' #c('Facebook_S_15','Facebook_S_27','Facebook_S_30','Facebook_S_34','Facebook_S_38','Google_S_1','Google_S_3',
#' #'affiliate_S_1','affiliate_S_2','affiliate_S_3','affiliate_S_4','affiliate_S_5','affiliate_S_6','affiliate_S_7',
#' #'affiliate_S_9','affiliate_S_10','affiliate_S_11','affiliate_S_12','affiliate_S_14',
#' #'affiliate_S_16','affiliate_S_17','affiliate_S_18','affiliate_S_19','affiliate_S_20','affiliate_S_21',
#' #'affiliate_S_22','affiliate_S_23','affiliate_S_24','affiliate_S_27')
#' 
#'   ,paid_media_spends = c('Facebook_S_1','Facebook_S_21','Facebook_S_22','Facebook_S_51','Facebook_S_54','Facebook_S_58','Facebook_S_62','Facebook_S_67','Facebook_S_71','Facebook_S_73','Facebook_S_74','Facebook_S_75','Facebook_S_77','Facebook_S_79','Facebook_S_80','Facebook_S_82','Google_S_1','Google_S_3','affiliate_S_1','affiliate_S_2','affiliate_S_3','affiliate_S_4','affiliate_S_5','affiliate_S_6','affiliate_S_7','affiliate_S_8','affiliate_S_9','affiliate_S_10','affiliate_S_11','affiliate_S_12','affiliate_S_13','affiliate_S_14','affiliate_S_16','affiliate_S_17','affiliate_S_18','affiliate_S_19','affiliate_S_20','affiliate_S_21','affiliate_S_22','affiliate_S_23','affiliate_S_24','affiliate_S_27','Yahoo_S_2')
#' 
#'   
#'  # mandatory input
#'   #,paid_media_vars = 
#' #c('Facebook_I_15','Facebook_I_27','Facebook_I_30','Facebook_I_34','Facebook_I_38','Google_I_1','Google_I_3',
#' #'affiliate_S_1','affiliate_S_2','affiliate_S_3','affiliate_S_4','affiliate_S_5','affiliate_S_6','affiliate_S_7',
#' #'affiliate_S_9','affiliate_S_10','affiliate_S_11','affiliate_S_12',
#' #'affiliate_S_14','affiliate_S_16','affiliate_S_17','affiliate_S_18','affiliate_S_19',
#' #'affiliate_S_20','affiliate_S_21','affiliate_S_22','affiliate_S_23','affiliate_S_24','affiliate_S_27')
#'   ,paid_media_vars = c('Facebook_I_1','Facebook_I_21','Facebook_I_22','Facebook_I_51','Facebook_I_54','Facebook_I_58','Facebook_I_62','Facebook_I_67','Facebook_I_71','Facebook_I_73','Facebook_I_74','Facebook_I_75','Facebook_I_77','Facebook_I_79','Facebook_I_80','Facebook_I_82','Google_I_1','Google_I_3','affiliate_S_1','affiliate_S_2','affiliate_S_3','affiliate_S_4','affiliate_S_5','affiliate_S_6','affiliate_S_7','affiliate_S_8','affiliate_S_9','affiliate_S_10','affiliate_S_11','affiliate_S_12','affiliate_S_13','affiliate_S_14','affiliate_S_16','affiliate_S_17','affiliate_S_18','affiliate_S_19','affiliate_S_20','affiliate_S_21','affiliate_S_22','affiliate_S_23','affiliate_S_24','affiliate_S_27','Yahoo_I_2')
#' 
#'     # mandatory.
#'   # paid_media_vars must have same order as paid_media_spends. Use media exposure metrics like
#'   # impressions, GRP etc. If not applicable, use spend instead.
#'   ,organic_vars = c('PR_R_1','PR_R_2','PR_R_3','PR_R_4','PR_R_5','PR_R_6','PR_R_7','dating_ticket','bachelor_ticket')
#' 
#'   #c('PR_I_1','PR_I_2','PR_I_3','PR_I_4','PR_I_5','PR_I_6','PR_I_7') # marketing activity without media spend
#'   #今の所なし,factor_vars = c("events") # specify which variables in context_vars or organic_vars are factorial
#'   ,window_start = "2021-08-17"
#'   ,window_end = "2022-04-19"
#'   ,adstock = "geometric" # geometric, weibull_cdf or weibull_pdf.
#' )

head(batch_data)

#' InputCollect <- robyn_inputs(
#'   dt_input = batch_data
#'   ,dt_holidays = holiday_data
#'   ,date_var = "DATE" # date format must be "2020-01-01"(YYYY-MM-DD)
#'   ,dep_var = "Conversion_3_male_Tokyo" # there should be only one dependent variable
#'   ,dep_var_type = "conversion" # "revenue" or "conversion"
#'   ,prophet_vars = c("trend", "season", "weekday" ,"holiday") # "trend","season", "weekday" & "holiday"
#'   ,prophet_country = "JP"# input one country. dt_prophet_holidays includes 59 countries by default
#'   ,context_vars = c('boolean_value_3',
#'                     'boolean_value_5',
#'                     'boolean_value_6',
#'                     'boolean_value_7',
#'                     'boolean_value_8',
#'                     #'boolean_value_9',
#'                     'boolean_value_10',
#'                     'boolean_value_12',
#'                     'boolean_value_13',
#'                     'boolean_value_14',
#'                     #'boolean_value_15',
#'                     'boolean_value_16',
#'                     #'boolean_value_18',
#'                     #'boolean_value_19',
#'                     'covid.19.Infected.person_1', #カラム名変更
#'                     'weather_Average.temperature..._1', #カラム名変更
#'                     'weather_Total.precipitation.mm._1', #カラム名変更
#'                     'weather_Daylight.hours..hours._1', #カラム名変更
#'                     'Number.of.dates_1', #カラム名変更
#'                     'Number.of.dates_2'
#'                     ,'Complementary.goods_1'
#'                     ,'Complementary.goods_2'
#'                     ,'Complementary.goods_3'#カラム名変更
#'                     ,'Influencer_Post'
#'                     ) ##'Influencer_Post',
#'                      # e.g. competitors, discount, unemployment etc
#'   ,paid_media_spends = c('boolean_value_S_1',
#'                          'Influencer_var_S',
#'                          'Influencer_fix_S',
#'                          'Yahoo_S',
#'                          'Yahoo_other_S',
#'                          'Twitter_S',
#'                          'Google_S',
#'                          'Google_other_S',
#'                          'affiliate',
#'                          'FB_S',
#'                          'FB_other_S') ##'Influencer_var_S', #'Influencer_fix_S',
#'   ,paid_media_vars = c('boolean_value_S_1',
#'                        'Influencer_var_S',
#'                        'Influencer_fix_S',
#'                        'Yahoo_I',
#'                        'Yahoo_other_I',
#'                        'Twitter_I',
#'                        'Google_I',
#'                        'Google_other_I',
#'                        'affiliate',
#'                        'FB_I',
#'                        'FB_other_I') 
#'   ,organic_vars = c('PR_I') # marketing activity without media spend
#'   ,factor_vars = c('boolean_value_3',
#'                    'boolean_value_5',
#'                    'boolean_value_6',
#'                    'boolean_value_7',
#'                    'boolean_value_8',
#'                    'boolean_value_10',
#'                    'boolean_value_12',
#'                    'boolean_value_13',
#'                    'boolean_value_14',
#'                    'boolean_value_16',
#'                    'Influencer_Post'
#'                    ) 　
#'   #'boolean_value_9', 
#'   #'boolean_value_15',
#'   #' #'boolean_value_18',
#'   #'boolean_value_19'#値１つしかない# specify which variables in context_vars or organic_vars are factorial
#'   ,window_start = "2020-10-22"
#'   ,window_end = "2022-03-31"
#'   ,adstock = "weibull_cdf" # geometric, weibull_cdf or weibull_pdf.
#' )

#データをGrouping化
InputCollect <- robyn_inputs(
  dt_input = batch_data
  ,dt_holidays = holiday_data
  ,date_var = "DATE" # date format must be "2020-01-01"(YYYY-MM-DD)
  ,dep_var = "Conversion_3_male_Tokyo" # there should be only one dependent variable
  ,dep_var_type = "conversion" # "revenue" or "conversion"
  ,prophet_vars = c("trend", "season", "weekday" ,"holiday") # "trend","season", "weekday" & "holiday"
  ,prophet_country = "JP"# input one country. dt_prophet_holidays includes 59 countries by default
  ,context_vars = c('boolean_value_3',
                    'boolean_value_5',
                    'boolean_value_6',
                    'boolean_value_7',
                    'boolean_value_8',
                    #'boolean_value_9',
                    'boolean_value_10',
                    'boolean_value_12',
                    'boolean_value_13',
                    'boolean_value_14',
                    #'boolean_value_15',
                    'boolean_value_16',
                    'boolean_value_18',
                    'boolean_value_19',
                    'covid.19.Infected.person_1', #カラム名変更
                    'weather_Average.temperature..._1', #カラム名変更
                    'weather_Total.precipitation.mm._1', #カラム名変更
                    'weather_Daylight.hours..hours._1', #カラム名変更
                    'Number.of.dates_1', #カラム名変更
                    'Number.of.dates_2'
                    ,'Complementary.goods_1'
                    ,'Complementary.goods_2'
                    ,'Complementary.goods_3'#カラム名変更
                    ,'Influencer_Post'
                    ,'price_16'
                    ,'Event'
                    ,'macroeconomic_indicators_1'
                    ,'macroeconomic_indicators_4'
                    ,'macroeconomic_indicators_13'
                    ,'macroeconomic_indicators_14'
  ) ##'Influencer_Post',
  # e.g. competitors, discount, unemployment etc
  ,paid_media_spends = c('boolean_value_S_1',
                         'Influencer_big_fix_S',
                         'Influencer_small_fix_S',
                         'Yahoo_S',
                         'Yahoo_other_S',
                         'Twitter_S',
                         'Google_other_S',
                         'FB_undefined_S',
                         'FB_u25_S',
                         'FB_28_similar_S',
                         'FB_30_broad_S',
                         'FB_30_similar_S',
                         'FB_30_retarg_S',
                         'FB_40_broad_S',
                         'FB_40_similar_S',
                         'FB_40_retarg_S',
                         'FB_50_S',
                         'FB_male_other_S',
                         'FB_female_other_S',
                         'Google_listing_S',
                         'Google_Proslisting_S',
                         'Google_undefined_S') ##'Influencer_var_S', #'Influencer_fix_S',
  ,paid_media_vars = c('boolean_value_S_1',
                       'Influencer_big_fix_S',
                       'Influencer_small_fix_S',
                       'Yahoo_I',
                       'Yahoo_other_I',
                       'Twitter_I',
                       'Google_other_I',
                       'FB_undefined_I',
                       'FB_u25_I',
                       'FB_28_similar_I',
                       'FB_30_broad_I',
                       'FB_30_similar_I',
                       'FB_30_retarg_I',
                       'FB_40_broad_I',
                       'FB_40_similar_I',
                       'FB_40_retarg_I',
                       'FB_50_I',
                       'FB_male_other_I',
                       'FB_female_other_I',
                       'Google_listing_I',
                       'Google_Proslisting_I',
                       'Google_undefined_I') 
  ,organic_vars = c('PR_I','Google_trends_1', 'Referral_P_1', 'Twitter_scrolling_increment_1') # marketing activity without media spend
  ,factor_vars = c('boolean_value_3',
                   'boolean_value_5',
                   'boolean_value_6',
                   'boolean_value_7',
                   'boolean_value_8',
                   'boolean_value_10',
                   'boolean_value_12',
                   'boolean_value_13',
                   'boolean_value_14',
                   'boolean_value_16',
                   'boolean_value_18',
                   'boolean_value_19',
                   'Event'
                    ) 　#'Influencer_Post'
  #'boolean_value_9', 
  #'boolean_value_15',
  #' #'boolean_value_18',
  #'boolean_value_19'#値１つしかない# specify which variables in context_vars or organic_vars are factorial
  ,window_start = "2020-05-06"
  ,window_end = "2022-03-31"
  ,adstock = "weibull_cdf" # geometric, weibull_cdf or weibull_pdf.
)


print(colnames(batch_data))
print(InputCollect)
# ?robyn_inputs for more info

#### 2a-2: Second, define and add hyperparameters

print(InputCollect$all_media)
## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
## Default media variable for modelling has changed from paid_media_vars to paid_media_spends.
## hyperparameter names needs to be base on paid_media_spends names. Run:
hyper_names(adstock = InputCollect$adstock, all_media = InputCollect$all_media)
## to see correct hyperparameter names. Check GitHub homepage for background of change.
## Also calibration_input are required to be spend names.
## ------------------------------------------------------------------------------------------ ##

## Guide to setup & understand hyperparameters

## 1. IMPORTANT: set plot = TRUE to see helper plots of hyperparameter's effect in transformation
plot_adstock(plot = FALSE)
plot_saturation(plot = FALSE)

## 2. Get correct hyperparameter names:
# All variables in paid_media_spends and organic_vars require hyperparameter and will be
# transformed by adstock & saturation.
# Run hyper_names() as above to get correct media hyperparameter names. All names in
# hyperparameters must equal names from hyper_names(), case sensitive.
# Run ?hyper_names to check parameter definition.

## 3. Hyperparameter interpretation & recommendation:

## Geometric adstock: Theta is the only parameter and means fixed decay rate. Assuming TV
# spend on day 1 is 100??? and theta = 0.7, then day 2 has 100*0.7=70??? worth of effect
# carried-over from day 1, day 3 has 70*0.7=49??? from day 2 etc. Rule-of-thumb for common
# media genre: TV c(0.3, 0.8), OOH/Print/Radio c(0.1, 0.4), digital c(0, 0.3)

## Weibull CDF adstock: The Cumulative Distribution Function of Weibull has two parameters
# , shape & scale, and has flexible decay rate, compared to Geometric adstock with fixed
# decay rate. The shape parameter controls the shape of the decay curve. Recommended
# bound is c(0.0001, 2). The larger the shape, the more S-shape. The smaller, the more
# L-shape. Scale controls the inflexion point of the decay curve. We recommend very
# conservative bounce of c(0, 0.1), because scale increases the adstock half-life greatly.

## Weibull PDF adstock: The Probability Density Function of the Weibull also has two
# parameters, shape & scale, and also has flexible decay rate as Weibull CDF. The
# difference is that Weibull PDF offers lagged effect. When shape > 2, the curve peaks
# after x = 0 and has NULL slope at x = 0, enabling lagged effect and sharper increase and
# decrease of adstock, while the scale parameter indicates the limit of the relative
# position of the peak at x axis; when 1 < shape < 2, the curve peaks after x = 0 and has
# infinite positive slope at x = 0, enabling lagged effect and slower increase and decrease
# of adstock, while scale has the same effect as above; when shape = 1, the curve peaks at
# x = 0 and reduces to exponential decay, while scale controls the inflexion point; when
# 0 < shape < 1, the curve peaks at x = 0 and has increasing decay, while scale controls
# the inflexion point. When all possible shapes are relevant, we recommend c(0.0001, 10)
# as bounds for shape; when only strong lagged effect is of interest, we recommend
# c(2.0001, 10) as bound for shape. In all cases, we recommend conservative bound of
# c(0, 0.1) for scale. Due to the great flexibility of Weibull PDF, meaning more freedom
# in hyperparameter spaces for Nevergrad to explore, it also requires larger iterations
# to converge.

## Hill function for saturation: Hill function is a two-parametric function in Robyn with
# alpha and gamma. Alpha controls the shape of the curve between exponential and s-shape.
# Recommended bound is c(0.5, 3). The larger the alpha, the more S-shape. The smaller, the
# more C-shape. Gamma controls the inflexion point. Recommended bounce is c(0.3, 1). The
# larger the gamma, the later the inflection point in the response curve.

## 4. Set individual hyperparameter bounds. They either contain two values e.g. c(0, 0.5),
# or only one value, in which case you'd "fix" that hyperparameter.

# Run hyper_limits() to check maximum upper and lower bounds by range
# Example hyperparameters ranges for Geometric adstock


hyperparameters <- list(
  
  boolean_value_S_1_alphas = c(0.5, 3),
  boolean_value_S_1_gammas = c(0.3, 1), 
  boolean_value_S_1_shapes = c(0.0001, 2), 
  boolean_value_S_1_scales = c(0, 0.1), 
  
  Influencer_big_fix_S_alphas = c(0.5, 3),
  Influencer_big_fix_S_gammas = c(0.3, 1),
  Influencer_big_fix_S_shapes = c(0.0001, 2),
  Influencer_big_fix_S_scales = c(0, 0.1),
  
  Influencer_small_fix_S_alphas = c(0.5, 3),
  Influencer_small_fix_S_gammas = c(0.3, 1),
  Influencer_small_fix_S_shapes = c(0.0001, 2),
  Influencer_small_fix_S_scales = c(0, 0.1),
  
  Yahoo_S_alphas = c(0.5, 3), 
  Yahoo_S_gammas = c(0.3, 1), 
  Yahoo_S_shapes = c(0.0001, 2),
  Yahoo_S_scales = c(0, 0.1), 
  
  Yahoo_other_S_alphas = c(0.5, 3), 
  Yahoo_other_S_gammas = c(0.3, 1), 
  Yahoo_other_S_shapes = c(0.0001, 2), 
  Yahoo_other_S_scales = c(0, 0.1), 
  
  Twitter_S_alphas = c(0.5, 3), 
  Twitter_S_gammas = c(0.3, 1), 
  Twitter_S_shapes = c(0.0001, 2), 
  Twitter_S_scales = c(0, 0.1), 
  
  Google_other_S_alphas = c(0.5, 3), 
  Google_other_S_gammas = c(0.3, 1), 
  Google_other_S_shapes = c(0.0001, 2), 
  Google_other_S_scales = c(0, 0.1), 

  FB_undefined_S_alphas = c(0.5, 3), 
  FB_undefined_S_gammas = c(0.3, 1), 
  FB_undefined_S_shapes = c(0.0001, 2), 
  FB_undefined_S_scales = c(0, 0.1), 
  FB_u25_S_alphas = c(0.5, 3), 
  FB_u25_S_gammas = c(0.3, 1), 
  FB_u25_S_shapes = c(0.0001, 2), 
  FB_u25_S_scales = c(0, 0.1), 
  FB_28_similar_S_alphas = c(0.5, 3),
  FB_28_similar_S_gammas = c(0.3, 1),
  FB_28_similar_S_shapes = c(0.0001, 2), 
  FB_28_similar_S_scales = c(0, 0.1), 
  FB_30_broad_S_alphas = c(0.5, 3), 
  FB_30_broad_S_gammas = c(0.3, 1), 
  FB_30_broad_S_shapes = c(0.0001, 2), 
  FB_30_broad_S_scales = c(0, 0.1), 
  FB_30_similar_S_alphas = c(0.5, 3),
  FB_30_similar_S_gammas = c(0.3, 1), 
  FB_30_similar_S_shapes = c(0.0001, 2), 
  FB_30_similar_S_scales = c(0, 0.1), 
  FB_30_retarg_S_alphas = c(0.5, 3), 
  FB_30_retarg_S_gammas = c(0.3, 1), 
  FB_30_retarg_S_shapes = c(0.0001, 2), 
  FB_30_retarg_S_scales = c(0, 0.1), 
  FB_40_broad_S_alphas = c(0.5, 3), 
  FB_40_broad_S_gammas = c(0.3, 1), 
  FB_40_broad_S_shapes = c(0.0001, 2), 
  FB_40_broad_S_scales = c(0, 0.1), 
  FB_40_similar_S_alphas = c(0.5, 3),
  FB_40_similar_S_gammas = c(0.3, 1),
  FB_40_similar_S_shapes = c(0.0001, 2), 
  FB_40_similar_S_scales = c(0, 0.1),
  FB_40_retarg_S_alphas = c(0.5, 3), 
  FB_40_retarg_S_gammas = c(0.3, 1), 
  FB_40_retarg_S_shapes = c(0.0001, 2),
  FB_40_retarg_S_scales = c(0, 0.1), 
  FB_50_S_alphas = c(0.5, 3), 
  FB_50_S_gammas = c(0.3, 1), 
  FB_50_S_shapes = c(0.0001, 2), 
  FB_50_S_scales = c(0, 0.1), 
  FB_male_other_S_alphas = c(0.5, 3), 
  FB_male_other_S_gammas = c(0.3, 1),
  FB_male_other_S_shapes = c(0.0001, 2),
  FB_male_other_S_scales = c(0, 0.1), 
  FB_female_other_S_alphas = c(0.5, 3), 
  FB_female_other_S_gammas = c(0.3, 1), 
  FB_female_other_S_shapes = c(0.0001, 2), 
  FB_female_other_S_scales = c(0, 0.1),
  
  Google_listing_S_alphas = c(0.5, 3),
  Google_listing_S_gammas = c(0.3, 1), 
  Google_listing_S_shapes = c(0.0001, 2), 
  Google_listing_S_scales = c(0, 0.1), 
  Google_Proslisting_S_alphas = c(0.5, 3), 
  Google_Proslisting_S_gammas = c(0.3, 1), 
  Google_Proslisting_S_shapes = c(0.0001, 2), 
  Google_Proslisting_S_scales = c(0, 0.1), 
  Google_undefined_S_alphas = c(0.5, 3), 
  Google_undefined_S_gammas = c(0.3, 1), 
  Google_undefined_S_shapes = c(0.0001, 2), 
  Google_undefined_S_scales = c(0, 0.1),

  PR_I_alphas = c(0.5, 3), 
  PR_I_gammas = c(0.3, 1), 
  PR_I_shapes = c(0.0001, 2), 
  PR_I_scales = c(0, 0.1), 
  Google_trends_1_alphas = c(0.5, 3), 
  Google_trends_1_gammas = c(0.3, 1), 
  Google_trends_1_shapes = c(0.0001, 2), 
  Google_trends_1_scales = c(0, 0.1),
  Referral_P_1_alphas = c(0.5, 3), 
  Referral_P_1_gammas = c(0.3, 1), 
  Referral_P_1_shapes = c(0.0001, 2), 
  Referral_P_1_scales = c(0, 0.1),
  
  Twitter_scrolling_increment_1_alphas = c(0.5, 3),
  Twitter_scrolling_increment_1_gammas = c(0.3, 1), 
  Twitter_scrolling_increment_1_shapes = c(0.0001, 2),
  Twitter_scrolling_increment_1_scales = c(0, 0.1)
)



# 
# #ワイブルcdf
# hyperparameters <- list(
# 
#   boolean_value_S_1_alphas = c(0.5, 3),
#   boolean_value_S_1_gammas = c(0.3, 1),
#   boolean_value_S_1_shapes = c(0.0001, 2),
#   boolean_value_S_1_scales = c(0, 0.1),
# 
#   Influencer_var_S_alphas = c(0.5, 3),
#   Influencer_var_S_gammas = c(0.3, 1),
#   Influencer_var_S_shapes = c(0.0001, 2),
#   Influencer_var_S_scales = c(0, 0.1),
# 
#   Influencer_fix_S_alphas = c(0.5, 3),
#   Influencer_fix_S_gammas = c(0.3, 1),
#   Influencer_fix_S_shapes = c(0.0001, 2),
#   Influencer_fix_S_scales = c(0, 0.1),
# 
#   Yahoo_S_alphas = c(0.5, 3),
#   Yahoo_S_gammas = c(0.3, 1),
#   Yahoo_S_shapes = c(0.0001, 2),
#   Yahoo_S_scales = c(0, 0.1),
# 
#   Yahoo_other_S_alphas = c(0.5, 3),
#   Yahoo_other_S_gammas = c(0.3, 1),
#   Yahoo_other_S_shapes = c(0.0001, 2),
#   Yahoo_other_S_scales = c(0, 0.1),
# 
#   Twitter_S_alphas = c(0.5, 3),
#   Twitter_S_gammas = c(0.3, 1),
#   Twitter_S_shapes = c(0.0001, 2),
#   Twitter_S_scales = c(0, 0.1),
# 
#   Google_S_alphas = c(0.5, 3),
#   Google_S_gammas = c(0.3, 1),
#   Google_S_shapes = c(0.0001, 2),
#   Google_S_scales = c(0, 0.1),
# 
#   Google_other_S_alphas = c(0.5, 3),
#   Google_other_S_gammas = c(0.3, 1),
#   Google_other_S_shapes = c(0.0001, 2),
#   Google_other_S_scales = c(0, 0.1),
# 
#   affiliate_alphas = c(0.5, 3),
#   affiliate_gammas = c(0.3, 1),
#   affiliate_shapes = c(0.0001, 2),
#   affiliate_scales = c(0, 0.1),
# 
#   FB_S_alphas = c(0.5, 3),
#   FB_S_gammas = c(0.3, 1),
#   FB_S_shapes = c(0.0001, 2),
#   FB_S_scales = c(0, 0.1),
# 
#   FB_other_S_alphas = c(0.5, 3),
#   FB_other_S_gammas = c(0.3, 1),
#   FB_other_S_shapes = c(0.0001, 2),
#   FB_other_S_scales = c(0, 0.1),
# 
#   PR_I_alphas = c(0.5, 3),
#   PR_I_gammas = c(0.3, 1),
#   PR_I_shapes = c(0.0001, 2),
#   PR_I_scales = c(0, 0.1)
#   )

# #ワイブルpdf
# hyperparameters <- list(
#   
#   boolean_value_S_1_alphas = c(0.5, 3), boolean_value_S_1_gammas = c(0.3, 1), boolean_value_S_1_shapes = c(0.0001, 10), boolean_value_S_1_scales = c(0, 0.1), Influencer_var_S_alphas = c(0.5, 3), Influencer_var_S_gammas = c(0.3, 1), Influencer_var_S_shapes = c(0.0001, 10), Influencer_var_S_scales = c(0, 0.1), Influencer_fix_S_alphas = c(0.5, 3), Influencer_fix_S_gammas = c(0.3, 1), Influencer_fix_S_shapes = c(0.0001, 10), Influencer_fix_S_scales = c(0, 0.1), Yahoo_S_alphas = c(0.5, 3), Yahoo_S_gammas = c(0.3, 1), Yahoo_S_shapes = c(0.0001, 10), Yahoo_S_scales = c(0, 0.1), Yahoo_other_S_alphas = c(0.5, 3), Yahoo_other_S_gammas = c(0.3, 1), Yahoo_other_S_shapes = c(0.0001, 10), Yahoo_other_S_scales = c(0, 0.1), Twitter_S_alphas = c(0.5, 3), Twitter_S_gammas = c(0.3, 1), Twitter_S_shapes = c(0.0001, 10), Twitter_S_scales = c(0, 0.1), Google_other_S_alphas = c(0.5, 3), Google_other_S_gammas = c(0.3, 1), Google_other_S_shapes = c(0.0001, 10), Google_other_S_scales = c(0, 0.1), affiliate_alphas = c(0.5, 3), affiliate_gammas = c(0.3, 1), affiliate_shapes = c(0.0001, 10), affiliate_scales = c(0, 0.1), FB_S_alphas = c(0.5, 3), FB_S_gammas = c(0.3, 1), FB_S_shapes = c(0.0001, 10), FB_S_scales = c(0, 0.1), Google_S_alphas = c(0.5, 3), Google_S_gammas = c(0.3, 1), Google_S_shapes = c(0.0001, 10), Google_S_scales = c(0, 0.1), FB_other_S_alphas = c(0.5, 3), FB_other_S_gammas = c(0.3, 1), FB_other_S_shapes = c(0.0001, 10), FB_other_S_scales = c(0, 0.1), PR_I_alphas = c(0.5, 3), PR_I_gammas = c(0.3, 1), PR_I_shapes = c(0.0001, 10), PR_I_scales = c(0, 0.1) 
# )

# Example hyperparameters ranges for Weibull CDF adstock
# facebook_S_alphas = c(0.5, 3)
# facebook_S_gammas = c(0.3, 1)
# facebook_S_shapes = c(0.0001, 2)
# facebook_S_scales = c(0, 0.1)

# Example hyperparameters ranges for Weibull PDF adstock
# facebook_S_alphas = c(0.5, 3
# facebook_S_gammas = c(0.3, 1)
# facebook_S_shapes = c(0.0001, 10)
# facebook_S_scales = c(0, 0.1)

#### 2a-3: Third, add hyperparameters into robyn_inputs()
OnlyVariablePrint <- function(table){
  len <- length(names(table))
  for(VarCount in 1:len){
    var <- length(levels(factor(table[,names(table)[VarCount]])))
    if( var == 1 ){
      print( names(table)[VarCount])
    }
  }
}
OnlyVariablePrint(batch_data)

InputCollect <- robyn_inputs(InputCollect = InputCollect, hyperparameters = hyperparameters)
print(InputCollect)

#### 2a-4: Fourth (optional), model calibration / add experimental input

## Guide for calibration source

# 1. We strongly recommend to use experimental and causal results that are considered
# ground truth to calibrate MMM. Usual experiment types are people-based (e.g. Facebook
# conversion lift) and geo-based (e.g. Facebook GeoLift).
# 2. Currently, Robyn only accepts point-estimate as calibration input. For example, if
# 10k$ spend is tested against a hold-out for channel A, then input the incremental
# return as point-estimate as the example below.
# 3. The point-estimate has to always match the spend in the variable. For example, if
# channel A usually has 100k$ weekly spend and the experimental holdout is 70%, input
# the point-estimate for the 30k$, not the 70k$.

## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
## As noted above, calibration channels need to be paid_media_spends name.
## ------------------------------------------------------------------------------------------ ##
# calibration_input <- data.frame(
#   # channel name must in paid_media_vars
#   channel = c("facebook_S",  "tv_S", "facebook_S"),
#   # liftStartDate must be within input data range
#   liftStartDate = as.Date(c("2018-05-01", "2018-04-03", "2018-07-01")),
#   # liftEndDate must be within input data range
#   liftEndDate = as.Date(c("2018-06-10", "2018-06-03", "2018-07-20")),
#   # Provided value must be tested on same campaign level in model and same metric as dep_var_type
#   liftAbs = c(400000, 300000, 200000),
#   # Spend within experiment: should match within a 10% error your spend on date range for each channel from dt_input
#   spend = c(421000, 7100, 240000),
#   # Confidence: if frequentist experiment, you may use 1 - pvalue
#   confidence = c(0.85, 0.8, 0.99),
#   # KPI measured: must match your dep_var
#   metric = c("revenue", "revenue", "revenue")
# )
# InputCollect <- robyn_inputs(InputCollect = InputCollect, calibration_input = calibration_input)


################################################################
#### Step 2b: For known model specification, setup in one single step

## Specify hyperparameters as in 2a-2 and optionally calibration as in 2a-4 and provide them directly in robyn_inputs()

# InputCollect <- robyn_inputs(
#   dt_input = dt_simulated_weekly
#   ,dt_holidays = dt_prophet_holidays
#   ,date_var = "DATE"
#   ,dep_var = "revenue"
#   ,dep_var_type = "revenue"
#   ,prophet_vars = c("trend", "season", "holiday")
#   ,prophet_country = "DE"
#   ,context_vars = c("competitor_sales_B", "events")
#   ,paid_media_spends = c("tv_S", "ooh_S",	"print_S", "facebook_S", "search_S")
#   ,paid_media_vars = c("tv_S", "ooh_S", 	"print_S", "facebook_I", "search_clicks_P")
#   ,organic_vars = c("newsletter")
#   ,factor_vars = c("events")
#   ,window_start = "2016-11-23"
#   ,window_end = "2018-08-22"
#   ,adstock = "geometric"
#   ,hyperparameters = hyperparameters # as in 2a-2 above
#   #,calibration_input = dt_calibration # as in 2a-4 above
# )

################################################################
#### Step 3: Build initial model

## Run all trials and iterations. Use ?robyn_run to check parameter definition
OutputModels <- robyn_run(
  InputCollect = InputCollect # feed in all model specification
  #, cores = NULL # default
  #, add_penalty_factor = FALSE # Untested feature. Use with caution.
  , iterations = 6000 # recommended for the dummy dataset #5/21 1000 #5/28 5000 converge #5/29 4000 not coverge #7000 convergeでも、saveができない
  
  , trials = 5 # recommended for the dummy dataset
  , outputs = FALSE # outputs = FALSE disables direct model output
)


print(OutputModels)

## Check MOO (multi-objective optimization) convergence plots
OutputModels$convergence$moo_distrb_plot
OutputModels$convergence$moo_cloud_plot
# check convergence rules ?robyn_converge


#Sys.setenv(R_FUTURE_FORK_ENABLE="false")
#options(future.fork.enable = FALSE)
#library(doParallel)
#library(iterators)
#registerDoParallel(5)

#robyn_object <- "~/batchelor/MyRobyn.RDS"
#robyn_object <- "~/MyRobyn.RDS"

## Calculate Pareto optimality, cluster and export results and plots. See ?robyn_outputs
OutputCollect <- robyn_outputs(
  InputCollect, OutputModels
  , pareto_fronts = 3
  # , calibration_constraint = 0.1 # range c(0.01, 0.1) & default at 0.1
  , csv_out = "pareto" # "pareto" or "all"
  , clusters = TRUE # Set to TRUE to cluster similar models by ROAS. See ?robyn_clusters
  , plot_pareto = TRUE # Set to FALSE to deactivate plotting and saving model one-pagers
  , plot_folder = robyn_object # path for plots export
)

?robyn_outputs
print(OutputCollect)




## Run & output in one go
# OutputCollect <- robyn_run(
#   InputCollect = InputCollect
#   #, cores = NULL
#   , iterations = 200
#   , trials = 2
#   #, add_penalty_factor = FALSE
#   , outputs = TRUE
#   , pareto_fronts = 3
#   , csv_out = "pareto"
#   , clusters = TRUE
#   , plot_pareto = TRUE
#   , plot_folder = robyn_object
# )
# convergence <- robyn_converge(OutputModels)
# convergence$moo_distrb_plot
# convergence$moo_cloud_plot
# print(OutputCollect)

## 4 csv files are exported into the folder for further usage. Check schema here:
## https://github.com/facebookexperimental/Robyn/blob/main/demo/schema.R
# pareto_hyperparameters.csv, hyperparameters per Pareto output model
# pareto_aggregated.csv, aggregated decomposition per independent variable of all Pareto output
# pareto_media_transform_matrix.csv, all media transformation vectors
# pareto_alldecomp_matrix.csv, all decomposition vectors of independent variables


################################################################
#### Step 4: Select and save the initial model

## Compare all model one-pagers and select one that mostly reflects your business reality

print(OutputCollect)
#####################20220518 ここから#################################
select_model <- "5_740_8" # select one from above
ExportedModel <- robyn_save(
  robyn_object = robyn_object # model object location and name
  , select_model = select_model # selected model ID
  , InputCollect = InputCollect # all model input
  , OutputCollect = OutputCollect # all model output
)
print(ExportedModel)
# plot(ExportedModel)

################################################################
#### Step 5: Get budget allocation based on the selected model above

## Budget allocation result requires further validation. Please use this recommendation with caution.
## Don't interpret budget allocation result if selected model above doesn't meet business expectation.

# Check media summary for selected model
OutputCollect$xDecompAgg[solID == select_model & !is.na(mean_spend)
                         , .(rn, coef,mean_spend, mean_response, roi_mean
                             , total_spend, total_response=xDecompAgg, roi_total, solID)]
# OR: print(ExportedModel)

# Run ?robyn_allocator to check parameter definition
# Run the "max_historical_response" scenario: "What's the revenue lift potential with the
# same historical spend level and what is the spend mix?"
AllocatorCollect1 <- robyn_allocator(
  InputCollect = InputCollect
  , OutputCollect = OutputCollect
  , select_model = select_model
  , scenario = "max_historical_response"
  , channel_constr_low = c(0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7)
  , channel_constr_up = c(1.2,1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2)
  , export = TRUE
  #, date_min = "2022-01-01"
  #, date_max = "2022-03-31"
)
?robyn_allocator
print(AllocatorCollect1)
# plot(AllocatorCollect1)

# Run the "max_response_expected_spend" scenario: "What's the maximum response for a given
# total spend based on historical saturation and what is the spend mix?" "optmSpendShareUnit"
# is the optimum spend share.
AllocatorCollect2 <- robyn_allocator(
  InputCollect = InputCollect
  , OutputCollect = OutputCollect
  , select_model = select_model
  , scenario = "max_response_expected_spend"
  , channel_constr_low = c(0.7)
  , channel_constr_up = c(1.2)
  , expected_spend = 10000 # Total spend to be simulated
  , expected_spend_days = 7 # Duration of expected_spend in days
  , export = TRUE
)
print(AllocatorCollect2)
AllocatorCollect2$dt_optimOut
# plot(AllocatorCollect2)



s <- 150000
for (i in 1:70) {
  AllocatorCollect2 <- robyn_allocator(
    InputCollect = InputCollect
    , OutputCollect = OutputCollect
    , select_model = select_model
    , scenario = "max_response_expected_spend"
    , channel_constr_low = c(0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7,0.7)
    , channel_constr_up = c(1.2,1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2)
    , expected_spend = s # Total spend to be simulated
    , expected_spend_days = 1 # Duration of expected_spend in days
    , export = TRUE
  )
  file.copy(from = "C:/Users/makoto.mizuguchi/Documents/batchelor/2022-06-22 18.52 init/5_740_8_reallocated_respo.png", to=paste('C:/Users/makoto.mizuguchi/Documents/batchelor/2022-06-22 18.52 init/invest_simu/', sprintf("5_740_8_reallocated_respo%d.png",s )))
  write.csv(AllocatorCollect2$dt_optimOut,file=sprintf("C:/Users/makoto.mizuguchi/Documents/batchelor/2022-06-22 18.52 init/invest_simu/%s_simulation%d.csv",select_model, s))
  s <-  s + 20000
}




#One page
install.packages('rdrr')
library(lares)
library(ggplot2)
library(reshape2)
library(ggplot2)
library(data.table)
library(cli)
library(tidyverse)
library(magrittr)
library(dplyr)
library(patchwork)
outputs <- list()
all_plots <- list()

sid <- "5_740_8"
select_model <- sid
temp <- OutputCollect$allPareto$plotDataCollect
file_name = "C:\\Users\\makoto.mizuguchi\\Documents\\batchelor\\2022-06-22 18.52 init\\predict.csv"

#Summary
plotDT_scurveMeanResponse <- OutputCollect$xDecompAgg[
  solID == select_model & rn %in% InputCollect$paid_media_spends]
errors <- paste0(
  "R2 train: ", plotDT_scurveMeanResponse[, round(mean(rsq_train), 4)],
  ", NRMSE = ", plotDT_scurveMeanResponse[, round(mean(nrmse), 4)],
  ", DECOMP.RSSD = ", plotDT_scurveMeanResponse[, round(mean(decomp.rssd), 4)],
  ", MAPE = ", plotDT_scurveMeanResponse[, round(mean(mape), 4)]
)
errors

# Spend x effect share comparison
plotMediaShareLoopBar <- temp[[sid]]$plot1data$plotMediaShareLoopBar
plotMediaShareLoopLine <- temp[[sid]]$plot1data$plotMediaShareLoopLine
ySecScale <- temp[[sid]]$plot1data$ySecScale
plotMediaShareLoopBar$variable <- stringr::str_to_title(gsub("_", " ", plotMediaShareLoopBar$variable))
type <- ifelse(InputCollect$dep_var_type == "conversion", "CPA", "ROI")
plotMediaShareLoopLine$type_colour <- type_colour <- "#03396C"
names(type_colour) <- "type_colour"
p1 <- ggplot(plotMediaShareLoopBar, aes(x = .data$rn, y = .data$value, fill = .data$variable)) +
  geom_bar(stat = "identity", width = 0.5, position = "dodge") +
  geom_text(aes(y = 0, label = paste0(round(.data$value * 100, 1), "%")),
            hjust = -.1, position = position_dodge(width = 0.5), fontface = "bold"
  ) +
  geom_line(
    data = plotMediaShareLoopLine, aes(
      x = .data$rn, y = .data$value / ySecScale, group = 1
    ),
    color = type_colour, inherit.aes = FALSE
  ) +
  geom_point(
    data = plotMediaShareLoopLine, aes(
      x = .data$rn, y = .data$value / ySecScale, group = 1, color = type_colour
    ),
    inherit.aes = FALSE, size = 3.5
  ) +
  geom_text(
    data = plotMediaShareLoopLine, aes(
      label = round(.data$value, 2), x = .data$rn, y = .data$value / ySecScale, group = 1
    ),
    color = type_colour, fontface = "bold", inherit.aes = FALSE, hjust = -.4, size = 4
  ) +
  scale_y_percent() +
  coord_flip() +
  theme_lares(axis.text.x = element_blank(), legend = "top", grid = "Xx") +
  scale_fill_brewer(palette = 3) +
  scale_color_identity(guide = "legend", labels = type) +
  labs(
    title = paste0("Share of Spend VS Share of Effect with total ", type),
    y = "Total Share by Channel", x = NULL, fill = NULL, color = NULL
  )


#Waterfall

plotWaterfallLoop <- temp[[sid]]$plot2data$plotWaterfallLoop
plotWaterfallLoop$sign <- ifelse(plotWaterfallLoop$sign == "pos", "Positive", "Negative")
p2 <- suppressWarnings(
  ggplot(plotWaterfallLoop, aes(x = id, fill = sign)) +
    geom_rect(aes(
      x = rn, xmin = id - 0.45, xmax = id + 0.45,
      ymin = end, ymax = start
    ), stat = "identity") +
    scale_x_discrete("", breaks = levels(plotWaterfallLoop$rn), labels = plotWaterfallLoop$rn) +
    scale_y_percent() +
    scale_fill_manual(values = c("Positive" = "#59B3D2", "Negative" =  "#E5586E")) +
    theme_lares(legend = "top") +
    geom_text(mapping = aes(
      label = paste0(formatNum(xDecompAgg, abbr = TRUE), "\n", round(xDecompPerc * 100, 1), "%"),
      y = rowSums(cbind(plotWaterfallLoop$end, plotWaterfallLoop$xDecompPerc / 2))
    ), fontface = "bold", lineheight = .7) +
    coord_flip() +
    labs(
      title = "Response Decomposition Waterfall by Predictor",
      x = NULL, y = NULL, fill = "Sign"
    )
)


# PredictionとActualの差
xDecom <- temp[[sid]]$plot5data$xDecompVecPlotMelted
print(xDecom$variable == "Predicted")
print(xDecom)
write.csv(x=xDecom, file = file_name)



#Response Curve

dt_scurvePlot <- temp[[sid]]$plot4data$dt_scurvePlot
dt_scurvePlotMean <- temp[[sid]]$plot4data$dt_scurvePlotMean
if (!"channel" %in% colnames(dt_scurvePlotMean)) dt_scurvePlotMean$channel <- dt_scurvePlotMean$rn
p4 <-ggplot(
  dt_scurvePlot[dt_scurvePlot$channel %in% InputCollect$paid_media_spends, ],
  aes(x = .data$spend, y = .data$response, color = .data$channel)
) +
  geom_line() +
  geom_point(data = dt_scurvePlotMean, aes(
    x = .data$mean_spend, y = .data$mean_response, color = .data$channel
  )) +
  geom_text(
    data = dt_scurvePlotMean, aes(
      x = .data$mean_spend, y = .data$mean_response, color = .data$channel,
      label = formatNum(.data$mean_spend, 2, abbr = TRUE)
    ),
    show.legend = FALSE, hjust = -0.2
  ) +
  theme_lares(pal = 2) +
  theme(
    legend.position = c(0.9, 0.2),
    legend.background = element_rect(fill = alpha("grey98", 0.6), color = "grey90")
  ) +
  labs(
    title = "Response Curves and Mean Spends by Channel",
    x = "Spend", y = "Response", color = NULL
  ) +
  scale_x_abbr() +
  scale_y_abbr()


#adstck
weibullCollect <- temp[[sid]]$plot3data$weibullCollect
wb_type <- temp[[sid]]$plot3data$wb_type
p3 <- ggplot(weibullCollect, aes(x = .data$x, y = .data$decay_accumulated)) +
  geom_line(aes(color = .data$channel)) +
  facet_wrap(~ .data$channel) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "gray") +
  geom_text(aes(x = max(.data$x), y = 0.5, vjust = -0.5, hjust = 1, label = "Halflife"), colour = "gray") +
  theme_lares(legend = "none", grid = "Xx") +
  labs(
    title = paste("Weibull", wb_type, "Adstock: Flexible Rate Over Time"),
    x = sprintf("Time unit [%ss]", InputCollect$intervalType), y = NULL
  )




#Allocation Curve

plotDT_saturation <- melt.data.table(OutputCollect$mediaVecCollect[
  solID == sid & type == "saturatedSpendReversed"
  ], id.vars = "ds", measure.vars = InputCollect$paid_media_spends, value.name = "spend", variable.name = "channel")
plotDT_saturation
plotDT_decomp <- melt.data.table(OutputCollect$mediaVecCollect[
  solID == sid & type == "decompMedia"
  ], id.vars = "ds", measure.vars = InputCollect$paid_media_spends, value.name = "response", variable.name = "channel")

plotDT_scurve <- data.frame(plotDT_saturation, response = plotDT_decomp$response) %>%
  filter(.data$spend >= 0) %>% as_tibble()

dt_optimOut = file.choose() #reallocationのファイルを選ぶ
dt_optimOut <- read.csv(dt_optimOut)
head(dt_optimOut)


#これができない
dt_optimOutScurve <- rbind(
  select(dt_optimOut, .data$channels, .data$initSpendUnit, .data$initResponseUnit) %>% mutate(type = "Initial"),
  select(dt_optimOut, .data$channels, .data$optmSpendUnit, .data$optmResponseUnit) %>% mutate(type = "Optimised"),
  use.names = FALSE
)
colnames(dt_optimOutScurve) <- c("channels", "spend", "response", "type")
dt_optimOutScurve <- dt_optimOutScurve %>%
  group_by(.data$channels) %>%
  mutate(spend_dif = dplyr::last(.data$spend) - dplyr::first(.data$spend),
         response_dif = dplyr::last(.data$response) - dplyr::first(.data$response))
#ここまで

plotDT_scurve
p14　<- ggplot(data = plotDT_scurve, aes(
  x = .data$spend, y = .data$response, color = .data$channel)) +
  geom_line() +
  #geom_point(data = dt_optimOutScurve, aes(
  #  x = .data$spend, y = .data$response,
  #  color = .data$channels, shape = .data$type
  #), size = 2.5) +
  # geom_text(
  #   data = dt_optimOutScurve, aes(
  #     x = .data$spend, y = .data$response, color = .data$channels,
  #     hjust = .data$hjust,
  #     label = formatNum(.data$spend, 2, abbr = TRUE)
  #   ),
  #   show.legend = FALSE
  # ) +
  theme_lares(legend.position = c(0.9, 0), pal = 2) +
  theme(
    legend.position = c(0.87, 0.5),
    legend.background = element_rect(fill = alpha("grey98", 0.6), color = "grey90"),
    legend.spacing.y = unit(0.2, 'cm')
  ) +
  labs(
    title = "Response Curve and Mean* Spend by Channel",
    x = "Spend", y = "Response", shape = NULL, color = NULL,
    caption = sprintf(
      "*Based on date range: %s to %s (%s)",
      #dt_optimOut$date_min[1],
      '2020/5/6',
      #dt_optimOut$date_max[1],
      '2022/3/31', 
      #dt_optimOut$periods[1]
      '695 days'
    )
  )



xDecompVecPlotMelted <- temp[[sid]]$plot5data$xDecompVecPlotMelted
xDecompVecPlotMelted$variable <- stringr::str_to_title(xDecompVecPlotMelted$variable)
xDecompVecPlotMelted$linetype <- ifelse(xDecompVecPlotMelted$variable == "Predicted", "solid", "dotted")
p5 <- ggplot(xDecompVecPlotMelted, aes(x = .data$ds, y = .data$value, color = .data$variable)) +
  geom_path(aes(linetype = .data$linetype), size = 0.6) +
  theme_lares(legend = "top", pal = 2) +
  scale_y_abbr() +
  guides(linetype = "none") +
  labs(
    title = "Actual vs. Predicted Response",
    x = "Date", y = "Response", color = NULL
  )


## 6. Diagnostic: fitted vs residual
xDecompVecPlot <- temp[[sid]]$plot6data$xDecompVecPlot
p6 <- qplot(x = .data$predicted, y = .data$actual - .data$predicted, data = xDecompVecPlot) +
  geom_hline(yintercept = 0) +
  geom_smooth(se = TRUE, method = "loess", formula = "y ~ x") +
  scale_x_abbr() + scale_y_abbr() +
  theme_lares() +
  labs(x = "Fitted", y = "Residual", title = "Fitted vs. Residual")


## Aggregate one-pager plots and export
onepagerTitle <- paste0("Model One-pager, on Pareto Front ", ", ID: ", sid)
pg <- wrap_plots(p2, p5, p1, p4, p3, p6, ncol = 2) +
  plot_annotation(title = onepagerTitle, subtitle = errors, theme = theme_lares(background = "white"))
all_plots[[sid]] <- pg

#Save
ggsave(
  filename = paste0(OutputCollect$plot_folder, "/", sid, ".png"),
  plot = pg, limitsize = FALSE,
  dpi = 400, width = 18, height = 18
)






















## A csv is exported into the folder for further usage. Check schema here:
## https://github.com/facebookexperimental/Robyn/blob/main/demo/schema.R

## QA optimal response

# Pick any media variable
select_media <- "search_S"
# For paid_media_spends set metric_value as your optimal spend
metric_value <- AllocatorCollect$dt_optimOut[channels == select_media, optmSpendUnit]
# # For paid_media_vars and organic_vars, manually pick a value
# metric_value <- 10000

if (TRUE) {
  optimal_response_allocator <- AllocatorCollect$dt_optimOut[channels == select_media, optmResponseUnit]
  optimal_response <- robyn_response(
    robyn_object = robyn_object,
    select_build = 0,
    media_metric = select_media,
    metric_value = metric_value)
  plot(optimal_response$plot)
  if (length(optimal_response_allocator) > 0) {
    cat("QA if results from robyn_allocator and robyn_response agree: ")
    cat(round(optimal_response_allocator) == round(optimal_response$response), "( ")
    cat(optimal_response$response, "==", optimal_response_allocator, ")\n")
  }
}

################################################################
#### Step 6: Model refresh based on selected model and saved Robyn.RDS object - Alpha

## NOTE: must run robyn_save to select and save an initial model first, before refreshing below
## The robyn_refresh() function is suitable for updating within "reasonable periods"
## Two situations are considered better to rebuild model:
## 1, most data is new. If initial model has 100 weeks and 80 weeks new data is added in refresh,
## it might be better to rebuild the model
## 2, new variables are added

# Run ?robyn_refresh to check parameter definition
Robyn <- robyn_refresh(
  robyn_object = robyn_object
  , dt_input = dt_simulated_weekly
  , dt_holidays = dt_prophet_holidays
  , refresh_steps = 13
  , refresh_mode = "auto"
  , refresh_iters = 1000 # 1k is estimation. Use refresh_mode = "manual" to try out.
  , refresh_trials = 3
  , clusters = TRUE
)

## Besides plots: there're 4 csv output saved in the folder for further usage
# report_hyperparameters.csv, hyperparameters of all selected model for reporting
# report_aggregated.csv, aggregated decomposition per independent variable
# report_media_transform_matrix.csv, all media transformation vectors
# report_alldecomp_matrix.csv,all decomposition vectors of independent variables

last_refresh_num <- sum(grepl('listRefresh', names(Robyn))) + 1 # Pick any refresh.
#Here's the final refresh using the model recommended by least combined normalized nrmse and decomp.rssd
ExportedRefreshModel <- robyn_save(
  robyn_object = robyn_object
  , select_model = Robyn[[last_refresh_num]]$OutputCollect$selectID
  , InputCollect = Robyn[[last_refresh_num]]$InputCollect
  , OutputCollect = Robyn[[last_refresh_num]]$OutputCollect
)

################################################################
#### Step 7: Get budget allocation recommendation based on selected refresh runs

# Run ?robyn_allocator to check parameter definition
AllocatorCollect <- robyn_allocator(
  robyn_object = robyn_object
  #, select_build = 1 # Use third refresh model
  , scenario = "max_response_expected_spend"
  , channel_constr_low = c(0.7, 0.7, 0.7, 0.7, 0.7)
  , channel_constr_up = c(1.2, 1.5, 1.5, 1.5, 1.5)
  , expected_spend = 2000000 # Total spend to be simulated
  , expected_spend_days = 14 # Duration of expected_spend in days
)
print(AllocatorCollect)
# plot(AllocatorCollect)

################################################################
#### Step 8: get marginal returns

## Example of how to get marginal ROI of next 1000$ from the 80k spend level for search channel

# Run ?robyn_response to check parameter definition

## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
## The robyn_response() function can now output response for both spends and exposures (imps,
## GRP, newsletter sendings etc.) as well as plotting individual saturation curves. New
## argument names "media_metric" and "metric_value" instead of "paid_media_var" and "spend"
## are now used to accommodate this change. Also the returned output is a list now and
## contains also the plot.
## ------------------------------------------------------------------------------------------ ##

# Get response for 80k from result saved in robyn_object
Spend1 <- 60000
Response1 <- robyn_response(
  robyn_object = robyn_object
  #, select_build = 1 # 2 means the second refresh model. 0 means the initial model
  , media_metric = "search_S"
  , metric_value = Spend1)
Response1$response/Spend1 # ROI for search 80k
Response1$plot

# Get response for 81k
Spend2 <- Spend1 + 1000
Response2 <- robyn_response(
  robyn_object = robyn_object
  #, select_build = 1
  , media_metric = "search_S"
  , metric_value = Spend2)
Response2$response/Spend2 # ROI for search 81k
Response2$plot

# Marginal ROI of next 1000$ from 80k spend level for search
(Response2$response - Response1$response)/(Spend2 - Spend1)

## Example of getting paid media exposure response curves
imps <- 50000000
response_imps <- robyn_response(
  robyn_object = robyn_object
  #, select_build = 1
  , media_metric = "facebook_I"
  , metric_value = imps)
response_imps$response / imps * 1000
response_imps$plot

## Example of getting organic media exposure response curves
sendings <- 30000
response_sending <- robyn_response(
  robyn_object = robyn_object
  #, select_build = 1
  , media_metric = "newsletter"
  , metric_value = sendings)
response_sending$response / sendings * 1000
response_sending$plot

################################################################
#### Optional: get old model results

# Get old hyperparameters and select model
dt_hyper_fixed <- data.table::fread("~/Desktop/2022-03-31 12.32 rf4/pareto_hyperparameters.csv")
select_model <- "1_25_9"
dt_hyper_fixed <- dt_hyper_fixed[solID == select_model]

OutputCollectFixed <- robyn_run(
  # InputCollect must be provided by robyn_inputs with same dataset and parameters as before
  InputCollect = InputCollect
  , plot_folder = robyn_object
  , dt_hyper_fixed = dt_hyper_fixed)

# Save Robyn object for further refresh
robyn_save(robyn_object = robyn_object
           , select_model = select_model
           , InputCollect = InputCollect
           , OutputCollect = OutputCollectFixed)