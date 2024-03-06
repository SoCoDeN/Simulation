import sys
import pandas as pd
import numpy as np
import datetime
import argparse
from glob import glob

dict_cols_required = ['subject_id', 'site_id', 'sex', 'dob', 'wave_number']
dict_cols_other = ['age', 'parental_education', 'autism_diagnosis', 'cbcl_externalizing_raw_score', 'cbcl_internalizing_raw_score', 'cbcl_attentionproblem_raw_score', 'iq', 'wm_volume', 'gm_volume', 'hippo_volume', 'amygdala_volume', 'frontal_lobe_gm_thickness', 'icv', 'brain_behavior_measurement_date']
dict_cols_all = dict_cols_required + dict_cols_other

def qc_checks(og):
    errors = []
    missing_cols = []
    extra_cols = []

    # make sure all column names (and only expected columns) are present
    if not all(item in list(og.columns) for item in dict_cols_all):
        errors.append('Column names do not match data dictionary')
        missing_cols = list(set(dict_cols_all) - set(og.columns))
        extra_cols = list(set(og.columns) - set(dict_cols_all))

    # remove extra columns from data frame
    if len(extra_cols)>0:
        cols = list(set(og.columns).intersection(dict_cols_all))
        df = og[cols]
    else:
        df = og

    # replace NA with NaN
    df = df.replace('NA', np.nan)

    # get columns in data frame that are required
    cols_required = list(set(df.columns).intersection(dict_cols_required))
    # make sure that there are non-NA values in all required columns
    if not df[cols_required].notnull().all().all():
        errors.append('Found NA entries in required columns')

    # make sure that site_id is the same for all rows
    if 'site_id' in df.columns:
        if not df['site_id'].eq(df['site_id'][0]).all():
            errors.append('site_id should be the same throughout the data file')

    # make sure age is < 20% missing and is within a 60 month and 264 month range
    if 'age' in df.columns:
        if (df['age'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('age has more than 20% of entries missing')
        # grab only not null ages
        age = df['age'][df['age'].notnull()]
        if min(age) < 60 or max(age) > 264:
            errors.append('age range is suspect, age(s) outside of 60 - 264 months found')

    # make sure that sex is only 0 or 1
    if 'sex' in df.columns:
        if not all([item==0 or item==1 for item in df['sex']]):
            errors.append('sex must be only either 0 or 1')

    # check dob format and that there are no years earlier than 2000
    if 'dob' in df.columns:
        try:
            dates = [datetime.date.fromisoformat(item) for item in df['dob']]
            if any(item.year < 2000 for item in dates):
                errors.append('dob is suspect, found year(s) of birth before 2000')
        except:
            print('dob date(s) are not in an appropriate format')

    # check brain_behavior_measurement_date is < 20% missing, proper format, and that there are no years earlier than 2000
    if 'brain_behavior_measurement_date' in df.columns:
        if (df['brain_behavior_measurement_date'].isnull().sum() * 100 / len(df)) > 20:
                errors.append('brain_behavior_measurement_date has more than 20% of entries missing')
        good_dates = df[df['brain_behavior_measurement_date'].notnull()]
        try:
            dates = [datetime.date.fromisoformat(item) for item in good_dates['brain_behavior_measurement_date']]
            if any(item.year < 2000 for item in dates):
                errors.append('brain_behavior_measurement_date is suspect, found year(s) of birth before 2000')
        except:
            print('brain_behavior_measurement_date date(s) are not in an appropriate format')

    # check that brain_behavior_measurement_date minus dob equals age
    if 'dob' in df.columns and 'age' in df.columns and 'brain_behavior_measurement_date' in df.columns:
        if not all([diff_month(r['brain_behavior_measurement_date'], r['dob'])==r['age'] for i, r in good_dates.iterrows()]):
            errors.append('brain_behavior_measurement_date minus dob should equal age, found entries where this is not true')

    # check to make sure wave_number is only 1-7
    if 'wave_number' in df.columns:
        if not df['wave_number'].isin(list(range(1, 8))).all():
            errors.append('wave_id entries need to be one of the following: 1, 2, 3, 4, 5, 6, 7')

    # check that all subject - wave pairs are unique
    if 'subject_id' in df.columns and 'wave_number' in df.columns:
        groups = df.groupby(['subject_id','wave_number']).size().reset_index().rename(columns={0:'count'})
        if any(groups['count'] > 1):
            errors.append('non-unique subject-wave pairs found')

    # check that parental education is < 20% missing and entries are appropriate and has a proper breakdown
    if 'parental_education' in df.columns:
        if (df['parental_education'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('parental_education has more than 20% of entries missing')
        # grab only not null parental_education
        educ = df['parental_education'][df['parental_education'].notnull()]
        if not educ.isin([0,1,2,3,777]).all():
            errors.append('parental_education entries need to be one of the following: 1, 2, 3, 777')
        else:
            # get proportions for 0, 1, 2, 3 (after rmoving 777)
            test = 1
            educ = educ[educ != 777]
            # 0 entries
            educ0 = (sum([i==0 for i in educ])/len(educ))*100
            if educ0 < 0.5 or educ0 > 10:
                test = 0
            # 1 entries
            educ1 = (sum([i==1 for i in educ])/len(educ))*100
            if educ1 < 30 or educ1 > 40:
                test = 0
            # 2 entries
            educ2 = (sum([i==2 for i in educ])/len(educ))*100
            if educ2 < 20 or educ2 > 30:
                test = 0
            # 3 entries
            educ3 = (sum([i==3 for i in educ])/len(educ))*100
            if educ2 < 30 or educ2 > 40:
                test = 0
            # check test
            if test==0:
                errors.append('parental_education entries are not close to correct proportions')

    # check that autism_diagnosis is < 20% missing and that values are either 0 or 1
    if 'autism_diagnosis' in df.columns:
        if (df['autism_diagnosis'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('autism_diagnosis has more than 20% of entries missing')
        # grab only not null autism_diagnosis
        asd = df['autism_diagnosis'][df['autism_diagnosis'].notnull()]
        if not all([item==0 or item==1 for item in asd]):
            errors.append('autism_diagnosis must be only either 0 or 1')

    # check that cbcl_externalizing_raw_score is < 20% missing and that values are between 0 and 70
    if 'cbcl_externalizing_raw_score' in df.columns:
        if (df['cbcl_externalizing_raw_score'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('cbcl_externalizing_raw_score has more than 20% of entries missing')
        # grab only not null cbcl_externalizing_raw_score
        cbcl_ext = df['cbcl_externalizing_raw_score'][df['cbcl_externalizing_raw_score'].notnull()]
        if min(cbcl_ext) < 0 or max(cbcl_ext) > 70:
            errors.append('cbcl_externalizing_raw_score range is suspect, entries should be between 0 and 70')

    # check that cbcl_internalizing_raw_score is < 20% missing and that values are between 0 and 64
    if 'cbcl_internalizing_raw_score' in df.columns:
        if (df['cbcl_internalizing_raw_score'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('cbcl_internalizing_raw_score has more than 20% of entries missing')
        # grab only not null cbcl_internalizing_raw_score
        cbcl_int = df['cbcl_internalizing_raw_score'][df['cbcl_internalizing_raw_score'].notnull()]
        if min(cbcl_int) < 0 or max(cbcl_int) > 64:
            errors.append('cbcl_internalizing_raw_score range is suspect, entries should be between 0 and 64')

    # check that cbcl_attentionproblem_raw_score is < 20% missing and that values are between 0 and 20
    if 'cbcl_attentionproblem_raw_score' in df.columns:
        if (df['cbcl_attentionproblem_raw_score'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('cbcl_attentionproblem_raw_score has more than 20% of entries missing')
        # grab only not null cbcl_attentionproblem_raw_score
        cbcl_att = df['cbcl_attentionproblem_raw_score'][df['cbcl_attentionproblem_raw_score'].notnull()]
        if min(cbcl_att) < 0 or max(cbcl_att) > 20:
            errors.append('cbcl_attentionproblem_raw_score range is suspect, entries should be between 0 and 20')

    # check that iq is < 20% missing and that values are between 0 and 200
    if 'iq' in df.columns:
        if (df['iq'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('iq has more than 20% of entries missing')
        # grab only not null cbcl_attentionproblem_raw_score
        iq = df['iq'][df['iq'].notnull()]
        if min(iq) < 0 or max(iq) > 200:
            errors.append('iq range is suspect, entries should be between the broad range of 0 and 200')

    # check that gm_volume measures are < 20% missing, positive, and less than 1,000,000
    if 'gm_volume' in df.columns:
        # check that < 20% missing
        if (df['gm_volume'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('gm_volume has more than 20% of entries missing')
        # grab only not null measurements
        v = df['gm_volume'][df['gm_volume'].notnull()]
        if not (v>0).all() or not (v<1000000).all():
            errors.append('gm_volume entries must all be greater than 0 and less than 1,000,000')

    # check that wm_volume measures are < 20% missing, positive, and less than 1,000,000
    if 'wm_volume' in df.columns:
        # check that < 20% missing
        if (df['wm_volume'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('wm_volume has more than 20% of entries missing')
        # grab only not null measurements
        v = df['wm_volume'][df['wm_volume'].notnull()]
        if not (v>0).all() or not (v<1000000).all():
            errors.append('wm_volume entries must all be greater than 0 and less than 1,000,000')

    # check that hippo_volume measures are < 20% missing, positive, and less than 20,000
    if 'hippo_volume' in df.columns:
        # check that < 20% missing
        if (df['hippo_volume'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('hippo_volume has more than 20% of entries missing')
        # grab only not null measurements
        v = df['hippo_volume'][df['hippo_volume'].notnull()]
        if not (v>0).all() or not (v<20000).all():
            errors.append('hippo_volume entries must all be greater than 0 and less than 20,000')

    # check that amygdala_volume measures are < 20% missing, positive, and less than 10,000
    if 'amygdala_volume' in df.columns:
        # check that < 20% missing
        if (df['amygdala_volume'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('amygdala_volume has more than 20% of entries missing')
        # grab only not null measurements
        v = df['amygdala_volume'][df['amygdala_volume'].notnull()]
        if not (v>0).all() or not (v<10000).all():
            errors.append('amygdala_volume entries must all be greater than 0 and less than 10,000')

    # check that frontal_lobe_gm_thickness measures are < 20% missing, positive, and less than 5
    if 'frontal_lobe_gm_thickness' in df.columns:
        # check that < 20% missing
        if (df['frontal_lobe_gm_thickness'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('frontal_lobe_gm_thickness has more than 20% of entries missing')
        # grab only not null measurements
        v = df['frontal_lobe_gm_thickness'][df['frontal_lobe_gm_thickness'].notnull()]
        if not (v>0).all() or not (v<5).all():
            errors.append('frontal_lobe_gm_thickness entries must all be greater than 0 and less than 5')

    # check that icv measures are < 20% missing, positive, and less than 5,000,000
    if 'icv' in df.columns:
        # check that < 20% missing
        if (df['icv'].isnull().sum() * 100 / len(df)) > 20:
            errors.append('icv has more than 20% of entries missing')
        # grab only not null measurements
        v = df['icv'][df['icv'].notnull()]
        if not (v>0).all() or not (v<5000000).all():
            errors.append('icv entries must all be greater than 0 and less than 5,000,000')

    missing_cols.sort()
    extra_cols.sort()
    
    return errors, missing_cols, extra_cols

def diff_month(d1,d2):
    # find the difference between two dates in months
    d1 = datetime.date.fromisoformat(d1)
    d2 = datetime.date.fromisoformat(d2)
    return (d1.year - d2.year) * 12 + d1.month - d2.month

def main():
    # parser
    parser = argparse.ArgumentParser()
    parser.add_argument('team_name', type=str)
    args = parser.parse_args()

    # set status
    fail = 0

    # find file(s)
    files = glob(f'./data/{args.team_name}/{args.team_name}*data*.csv')
    if len(files)==0:
        print('ERROR: No data files found!')
        fail = 1
    else:
        # loop through and QC each data file
        print(f'++ {len(files)} data files found')
        print('++ ---------')
        for file in sorted(files):
            print(f'++ Checking data file: {file}')
            df = pd.read_csv(file)
            #errors, missing, extra = qc_checks(df)
            try:
                df = pd.read_csv(file)
                errors, missing, extra = qc_checks(df)
                if len(errors) > 0:
                    print(f'++ {len(errors)} ERRORS FOUND:')
                    fail = 1
                    for e in errors:
                        print(f'    {e}')
                    if len(missing)>0:
                        print('++ Missing columns:')
                        for col in missing:
                            print(f'    {col}')
                    if len(extra)>0:
                        print('++ Extra columns found:')
                        for col in extra:
                            print(f'    {col}')
                else:
                    print('++ No errors found!')
            except:
                print(f'ERROR: There was a problem reading data file: {file}')
                fail = 1
            print('++ ----------')

    # exit codes
    if fail==1:
        print('++ Finished with errors.')
        sys.exit(1)
    elif fail==0:
        print('++ Finished without errors!')
        sys.exit(0)

if __name__ == "__main__":
    main()