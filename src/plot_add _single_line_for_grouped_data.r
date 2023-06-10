# <<<<<<< HEAD
### 在20020519_02_Fig2_BCD_outdoorData_analysis.r中有完整代码
# =======
### 在20220519_02_Fig2_BCD_outdoorData_analysis.r中有完整代码
# >>>>>>> 375ab22d9f09866196601c62505fb36de61d3e07
### 这里的代码仅为展示如何设置

################滑行时间
Fig2_extra2 <-
  ggplot(data = data_new_2to8instars, 
         aes(x = Instar_new, y = Gliding_dur_s, color = Sex_new, fill=Sex_new)) +
  geom_point(position=position_jitterdodge(0.6), size=4, shape=20) +
  ##由于第一行代码中 color 和 fill 参数将数据依据 Sex_new进行了分组标记, 下面geom_smooth会按照次分组添加相应数量的回归线
  geom_smooth(method = "lm", se =F) + 
  ## 通过aes(group = "NONE")将上面的分组取消就可以添加所有数据的趋势线
  geom_smooth(method = "lm", se =F, aes(group = "NONE")) +
  # geom_boxplot(width = 0.6, position=position_dodge(0.9), alpha = 0) +
  # geom_point(position=position_jitterdodge(0.2))+
  # stat_summary(fun = "mean", color="black", shape=15, 
  #              position=position_dodge(0.9))+
  # scale_y_continuous(limits = c(0, 14.8))+ #限定y轴的数值范围
  # scale_x_continuous(breaks = c(2,3,4,5,6,7,8))+ #限定y轴的数值范围
  # xlab("Instar")+
  # ylab("Gliding duration (s)")+
  # theme_classic()+
  # theme_custom+
  # theme(legend.position = "top",
  #       legend.title = element_blank())
  # 
  # 
