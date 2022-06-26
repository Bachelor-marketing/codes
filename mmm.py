import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

import urllib


def main():

    
    st.set_page_config(page_title="Marketing Science Kit",
                        page_icon=":bar_chart:" )
    
    marketing_kits = ["マーケティングミックスモデル", "アトリビューションモデル", "反実仮想", 
                    "Twitter分析", "ペルソナ分析", "離反顧客分析"]
    
    marketing_kit = st.sidebar.selectbox(
            'マーケティングサイエンスの手法を選択：',marketing_kits
        )

    if marketing_kit == "マーケティングミックスモデル":
        ######データバージョン情報######

        ######モデルの正確性確認セクション######

        ###男性の最新#######
        
        ##最新：　　ThinkPad: 2022-06-22 18.52 init
        ##１個前：　Surface: 2022-06-11 19.00 init
        ##２個前：　Surface: 2022-06-09 06.35 init

        

        ###女性の最新#######
        
        ##最新：　　ThinkPad: 2022-06-26 08.54 init
        ##１個前：　Surface: 2022-06-11 10.16 init
        ##２個前：　ThinkPad: 2022-06-06 08.46 init


        referrence = "Bachelor-marketing" # gucchi123 or Bachelor-marketing

        if referrence == "gucchi123":
            t_male_modelfit_date = "2022年6月11日"
            t_female_modelfit_date = "2022年6月11日"

            ######広告チャネルの金額確認######
            t_male_sim_date = "2022年6月11日"
            t_female_sim_date = "2022年6月11日"

            ######モデルの正確性確認セクション######
            ma_ping = "1_1334_1"
            fe_ping = "1_2335_4"
            
            
            #男性 　　　
            #6/5 = "5_1733_1.png"
            #latest #6/6 Surfaceの2022-06-06 00.40 init
            male_modelfit_ping = "{}.png".format(ma_ping)
            
            #女性
            #latest #6/5 ThinkPadの2022-06-06 08.46 init（ただし、以下のPNGとは別のものであるため最終的に整合させる）
            female_modelfit_ping = "{}.png".format(fe_ping)
            
            ######広告チャネルの金額確認########
            male_simu_file   = "{}_reallocated_hist.png".format(ma_ping)
            female_simu_file = "{}_reallocated_hist.png".format(fe_ping)
        
            
            ######データインプット######
            #男性
            
            file_type = "git"  # git or local
            
            #男性
            male_training_data = "batch491-1186-%E7%94%B7%E6%80%A7.csv" 
            male_optimized_file = "{}_reallocated.csv".format(ma_ping)
            
            #女性
            female_training_data = "batch491-1186-%E5%A5%B3%E6%80%A7.csv" 
            female_optimized_file = "{}_reallocated.csv".format(fe_ping)
                

            male_link = '[東京男性 元データとその他の分析結果の確認](https://github.com/{}/male_mmm_data)'.format(referrence)
            female_link = '[東京女性 元データとその他の分析結果の確認](https://github.com/{}/female_mmm_data)'.format(referrence)
        
        else:
            t_male_modelfit_date = "2022年6月26日"
            t_female_modelfit_date = "2022年6月26日"

            ######広告チャネルの金額確認######
            t_male_sim_date = "2022年6月26日"
            t_female_sim_date = "2022年6月26日"

            ######モデルの正確性確認セクション######
            ma_ping = "5_740_8"
            fe_ping = "5_1246_6"
            
            
            #男性 　　　
            #6/5 = "5_1733_1.png"
            #latest #6/6 Surfaceの2022-06-06 00.40 init
            male_modelfit_ping = "{}.png".format(ma_ping)
            
            #女性
            #latest #6/5 ThinkPadの2022-06-06 08.46 init（ただし、以下のPNGとは別のものであるため最終的に整合させる）
            female_modelfit_ping = "{}.png".format(fe_ping)
            
            ######広告チャネルの金額確認########
            male_simu_file   = "{}_reallocated_hist.png".format(ma_ping)
            female_simu_file = "{}_reallocated_hist.png".format(fe_ping)
        
            
            ######データインプット######
            #男性
            
            file_type = "git"  # git or local
            
            #男性
            male_training_data = "batch491-1186-%E7%94%B7%E6%80%A7.csv" 
            male_optimized_file = "{}_reallocated.csv".format(ma_ping)
            
            #女性
            female_training_data = "batch491-1186-%E5%A5%B3%E6%80%A7.csv" 
            female_optimized_file = "{}_reallocated.csv".format(fe_ping)
                

            male_link = '[東京男性 元データとその他の分析結果の確認](https://github.com/{}/male_mmm_data)'.format(referrence)
            female_link = '[東京女性 元データとその他の分析結果の確認](https://github.com/{}/female_mmm_data)'.format(referrence)




        
        dolists = ["モデルの正確性確認", "広告チャネルの金額確認", "投資金額毎のシミュレーション"]
        DoList = st.sidebar.selectbox(
            '確認したい事項を選択：',dolists
        )

        gender = ["東京男性","東京女性"]

        if DoList == "モデルの正確性確認":
            selected_gender = st.sidebar.selectbox(
                '性別を選択：',gender
            )

            def gitmodelfit(selected_gender, pngfile):
                st.header('＜{}＞モデルの適合度'.format(selected_gender))
                
                if selected_gender == "東京男性":
                    st.markdown(male_link, unsafe_allow_html=True) 
                    st.image("https://raw.githubusercontent.com/{}/male_mmm_data/main/{}".format(referrence,pngfile))
                elif selected_gender == "東京女性":
                    st.markdown(female_link, unsafe_allow_html=True) 
                    st.image("https://raw.githubusercontent.com/{}/female_mmm_data/main/{}".format(referrence, pngfile))    

            if selected_gender == "東京男性":
                pngfile=male_modelfit_ping
                gitmodelfit(selected_gender, pngfile)
            elif selected_gender == "東京女性":
                pngfile=female_modelfit_ping
                gitmodelfit(selected_gender, pngfile)


        elif DoList == "広告チャネルの金額確認":

            def visualization(selected_gender, training_data, optimzed_data ):
                st.header('＜{}＞広告最適化ダッシュボード:bar_chart:'.format(selected_gender))
                if selected_gender == "東京男性":
                    st.markdown(male_link, unsafe_allow_html=True)
                else:
                    st.markdown(female_link, unsafe_allow_html=True)
                channels = ["シミュレート結果一覧","Facebook広告", "Google広告", "Influencer固定報酬", "Offline施策", "Yahoo広告", "Twitter広告"]
                selected_channel = st.sidebar.selectbox(
                '広告チャネルを選択：',channels)

                if selected_gender=="東京男性":
                    if file_type == "git":
                        training_data_path = "https://raw.githubusercontent.com/{}/male_mmm_data/main/{}".format(referrence,training_data)
                        optimized_file = "https://raw.githubusercontent.com/{}/male_mmm_data/main/{}".format(referrence,optimzed_data)
                    elif file_type == "local":
                        training_data_path = "batch491-1186-男性.csv"
                        optimized_file = "4_1401_4_reallocated.csv"
                else:
                    training_data_path = "https://raw.githubusercontent.com/{}/female_mmm_data/main/{}".format(referrence, training_data)
                    optimized_file = "https://raw.githubusercontent.com/{}/female_mmm_data/main/{}".format(referrence, optimzed_data)
                
                #st.write(training_data_path)
                df_training = pd.read_csv(training_data_path, encoding="cp932")

                def investment(channel, file, data):
                    result_data = pd.read_csv(file, encoding="CP932")
                    selected = result_data.loc[result_data.loc[:,"channels"]==channel,:]
                    st.subheader("広告項目：{}".format(channel))
                    fig = plt.figure(figsize=(6,3))
                    plt.title("Spend for {} per day".format(channel))
                    plt.vlines(selected.loc[:, "initSpendUnit"], 0, 50, "0.3", linestyles='dashed', label="Current Ave")
                    plt.vlines(selected.loc[:, "optmSpendUnit"], 0, 50, "red", linestyles='dashed', label="Optm Ave")
                    st.write("＜1日あたりの{}消化金額サマリー＞".format(channel))
                    
                    names = ["現状投資額(Current Ave)","最適値投資額(Optm Ave)", "広告投資金額差分", "CPA改善差分"]
                    num_columns = len(names)
                    cols = st.columns(num_columns)
                    for name, col in zip(names, cols):
                        if name == names[0]:
                            try:
                                value = int(selected.loc[:, "initSpendUnit"].iloc[-1])
                                col.metric(label=name, value=f'{value:,} 円')
                            except IndexError:
                                st.write("＜データサンプル＞")
                                st.write("最初の期間の５件")
                                st.write(data.loc[ data.loc[:, channel]>0 ,["DATE", channel]].head())
                                st.write("最後の期間の５件")
                                st.write(data.loc[ data.loc[:, channel]>0 ,["DATE", channel]].tail())
                                value = data.loc[ data.loc[:, channel]>0 ,channel].mean()
                                col.metric(label=name, value=f'{value:,.3f} 円')
                                
                        if name == names[1]:
                            try:
                                value = int(selected.loc[:, "optmSpendUnit"].iloc[-1])
                                col.metric(label=name, value=f'{value:,} 円')
                            except:
                                value = 0
                                col.metric(label=name, value=f'{value:,.3f} 円')
                        if name == names[2]:
                            try:
                                value = int(selected.loc[:, "optmSpendUnit"].iloc[-1]) - int(selected.loc[:, "initSpendUnit"].iloc[-1])
                                col.metric(label=name, value=f'{value:,} 円')
                            except:
                                value = 0 - data.loc[ data.loc[:, channel]>0 ,channel].mean()
                                col.metric(label=name, value=f'{value:,.3f} 円')
                                st.write("※1 CPAへの寄与は確認されませんでした")
                                st.text("(現状投資金額に金額が入っている場合には回帰分析の結果の傾きは０の場合となります。金額が入っていない場合(nan)には投資をしていない広告配信戦略となります)")
                                st.write("※2 データ分析上は段階的に投資金額を減らしていくことが推奨されています")
                                st.text("(一律に0にするとCPAに影響が出る可能性があるため、十分に検討の上での意思決定が必要となります)")
                        if name == names[3]:
                            try:
                                value = selected.loc[:, "optmResponseUnitLift"].iloc[-1]
                                col.metric(label=name, value=f'{value:,.3f} 円')
                            except:
                                value = 0
                                col.metric(label=name, value=f'{value:,.3f} 円')         

                    
                    #st.write(data.loc[ data.loc[:, channel]>0 ,channel])
                    st.write('')
                    plt.hist(data.loc[ data.loc[:, channel]>0 ,channel], bins=6, color="0.8")
                    plt.legend()
                    st.write("＜グラフ：過去の平均消費金額と最適化＞")
                    st.text("（注）縦軸は出現回数、横軸は１日の投資金額")
                    st.pyplot(fig)
                    st.write('')
                    st.write('-----------------------------------------------------------------------')
                    
                if selected_channel == "シミュレート結果一覧":
                    if selected_gender=="東京男性":
                        st.image("https://raw.githubusercontent.com/{}/male_mmm_data/main/{}".format(referrence,male_simu_file))
                    else:
                        st.image("https://raw.githubusercontent.com/{}/female_mmm_data/main/{}".format(referrence, female_simu_file))

                if selected_channel == "Facebook広告":
                    selected_channels = [ i for i in df_training.columns if "FB" in i if "_S" in i]
                    #st.write(selected_channels)
                    for channel in selected_channels:
                        #st.write(channel)
                        investment(channel, optimized_file, df_training)

                if selected_channel == "Google広告":
                    selected_channels = [ i for i in df_training.columns if "Google" in i if "_S" in i]
                    #st.write(selected_channels)
                    for channel in selected_channels:
                        #st.write(channel)
                        investment(channel, optimized_file, df_training)

                if selected_channel == "Influencer固定報酬":
                    selected_channels = [ i for i in df_training.columns if "Influencer" in i if "_S" in i]
                    #st.write(df_training.columns)
                    for channel in selected_channels:
                        #st.write(channel)
                        investment(channel, optimized_file, df_training)

                if selected_channel == "Yahoo広告":
                    selected_channels = [ i for i in df_training.columns if "Yahoo" in i if "_S" in i]
                    #st.write(selected_channels)
                    for channel in selected_channels:
                        #st.write(channel)
                        investment(channel, optimized_file, df_training)

                if selected_channel == "Twitter広告":
                    selected_channels = [ i for i in df_training.columns if "Twitter" in i if "_S" in i]
                    #st.write(selected_channels)
                    for channel in selected_channels:
                        #st.write(channel)
                        investment(channel, optimized_file, df_training)


                if selected_channel == "Offline施策":
                    selected_channels = [ i for i in df_training.columns if "boolean" in i if "_S" in i]
                    #st.write(selected_channels)
                    for channel in selected_channels:
                        #st.write(channel)
                        investment(channel, optimized_file, df_training)        

            selected_gender = st.sidebar.selectbox(
                '性別を選択：',gender
            )            

            if selected_gender == "東京男性":
                visualization(selected_gender, male_training_data,male_optimized_file)
    
            elif selected_gender == "東京女性":
                visualization(selected_gender, female_training_data,female_optimized_file)

        elif DoList == "投資金額毎のシミュレーション":
            selected_gender = st.sidebar.selectbox(
                '性別を選択：',gender
            )

            def simu_visualization(gender, ping):
                st.header("＜{}＞投資金額毎の最適投資割合によるCV変動分析".format(selected_gender))
                #st.subheader("現状とシミュレーションとしての投資金額(*)の増減割合")
                #st.write("（*）150,000円 - 1,530,000円")
                #st.image("https://raw.githubusercontent.com/{}/{}_mmm_data/main/invest_simu/Total_Spend_Increase.png".format(referrence,gender))
                #st.write('-----------------------------------------------------------------------')
                st.subheader("投資金額(*)を変動させた場合のCV数の増加割合")
                st.write("（*）150,000円 - 1,530,000円")
                url = "https://raw.githubusercontent.com/{}/{}_mmm_data/main/invest_simu/Total_Response_Increase.png".format(referrence,gender)
                st.image(url)
                st.write("")
                st.write('-----------------------------------------------------------------------')
                st.subheader("投資金額毎の分析結果")
                
                for trial in range(150000, 1550000, 20000):
                    st.write("１日の広告投資金額の総額{:,}円".format(trial))
                    try:
                        download_url = "https://raw.githubusercontent.com/{}/{}_mmm_data/main/invest_simu/{}_reallocated_respo{}.png".format(referrence, gender, ping, trial)
                        data = urllib.request.urlopen(download_url).read()
                        st.image("https://raw.githubusercontent.com/{}/{}_mmm_data/main/invest_simu/{}_reallocated_respo{}.png".format(referrence,gender, ping, trial))
                    except:   
                        st.image("https://raw.githubusercontent.com/{}/{}_mmm_data/main/invest_simu/%20{}_reallocated_respo{}.png".format(referrence,gender, ping, trial))
                        
                    st.write('-----------------------------------------------------------------------')


            if selected_gender == "東京男性":
                simu_visualization("male", ma_ping)
            elif selected_gender == "東京女性":
                simu_visualization("female", fe_ping)
                   
        #データ更新日
        st.sidebar.write("")
        st.sidebar.write("<バージョン管理情報>")
        st.sidebar.text("モデルの正確性")
        st.sidebar.text("東京男性:{}".format( t_male_modelfit_date ))
        st.sidebar.text("東京女性:{}".format( t_female_modelfit_date ))
        st.sidebar.write("")
        st.sidebar.text("広告投資金額シミュレーション")
        st.sidebar.text("東京男性:{}".format( t_male_sim_date ))
        st.sidebar.text("東京女性:{}".format( t_female_sim_date ))
    

    elif marketing_kit == "アトリビューションモデル":
        st.write("アトリビューションモデルの分析結果を確認したい場合には、追加でお問い合わせください")
        st.write("")
        st.write("＜イメージ＞")
        st.image("https://raw.githubusercontent.com/gucchi123/MarketingKits/main/MTA.PNG")
        st.write("")
        st.write("＜必要データ＞")
        st.write("ユーザーID単位でのウェブ行動データ")
    
    
    elif marketing_kit == "反実仮想":
        st.write("反実仮想(過去コンバージョンしなかったユーザーをもしコンバージョンさせる場合、どんな特性を持っていればよいか？)の分析結果を確認したい場合には、追加でお問い合わせください")
        st.write("")
        st.write("＜イメージ＞")
        st.image("https://raw.githubusercontent.com/gucchi123/MarketingKits/main/CounterFactual.PNG")
        st.write("")
        st.write("＜必要データ＞")
        st.write("ユーザーID単位でのユーザー登録情報・ユーザー行動データ・コンバージョン有無")
    
    elif marketing_kit == "Twitter分析":
        st.write("Twitter分析（プロダクト改善のための感情分析）の分析結果を確認したい場合には、追加でお問い合わせください")
        st.write("")
        st.write("＜イメージ＞")
        st.image("https://raw.githubusercontent.com/gucchi123/MarketingKits/main/WordCloud.jpg")
        st.text("ツイッターのデータを用いて、ポジネガ分析・WordCloud等のプロダクト改善のヒントをご提供します")
        st.write("")
        st.write("＜必要データ＞")
        st.write("Twitter API情報")
        
    
    
    elif marketing_kit == "ペルソナ分析":
        st.write("ペルソナ分析の分析結果を確認したい場合には、追加でお問い合わせください")
        st.write("")
        st.write("＜イメージ＞")
        st.image("https://raw.githubusercontent.com/gucchi123/MarketingKits/main/Free-Personas-Vector.png")
        st.write("")
        st.write("＜必要データ＞")
        st.write("ユーザーID単位でのユーザー登録情報・ユーザー行動データ・コンバージョン有無")
    

    elif marketing_kit == "離反顧客分析":
        st.write("離反分析の分析結果を確認したい場合には、追加でお問い合わせください")
        st.write("")
        st.write("＜イメージ＞")
        st.image("https://raw.githubusercontent.com/gucchi123/MarketingKits/main/churn.png")
        st.write("＜必要データ＞")
        st.write("ユーザーID単位でのユーザー登録情報・ユーザー行動データ・離反有無")
        


if __name__ == '__main__':
    main()