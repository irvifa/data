library(tidyverse)
library(grid)
library(gridExtra)
library(flextable)

str(ToothGrowth)

summary(ToothGrowth$supp)

ToothGrowth %>% group_by(dose) %>% count()

summary(ToothGrowth$len)

ggplot(ToothGrowth, aes(x=len))+
  geom_histogram(bins = 6, fill= "steelblue1", colour="black")+
  geom_vline(xintercept = mean(ToothGrowth$len),lwd=1,colour="red")+
  geom_vline(xintercept = median(ToothGrowth$len),lwd=1,colour="green")+
  annotate("text",c(17.5,20.5),c(15,16),
           label=c("Mean","Median"),
           colour= c("red","green4"))+
  ylab("Frequency")+
  ggtitle("Frequency of len (Tooth length)")+
  theme(plot.title = element_text(hjust = 0.5))

ToothGrowth %>% group_by(supp) %>% summarise(n=n(),
                                             mean=round(mean(len),2),
                                             sd=round(sd(len),2)) %>% 
  flextable() %>%
  align(align = "center",part = "all")%>%
  set_caption(caption = "Average tooth length (len) and standard deviation by supplement type (supp)")%>%
  width(width = 1.5)

ToothGrowth %>% group_by(dose) %>% summarise(n=n(),
                                             mean=round(mean(len),2),
                                             sd=round(sd(len),2)) %>% 
  flextable() %>%
  align(align = "center",part = "all")%>%
  set_caption(caption = "Average tooth length (len) and standard deviation by dose")%>%
  width(width = 1.5)

ToothGrowth %>% group_by(supp,dose) %>% summarise(n=n(),
                                                  mean=round(mean(len),2),
                                                  sd=round(sd(len),2)) %>% 
  flextable() %>%
  align(align = "center",part = "all")%>%
  set_caption(caption = "Average tooth length (len) and standard deviation by supplement type (supp) and dose")%>%
  width(width = 1.5)

a<-ToothGrowth %>% group_by(supp) %>% summarise(meanlen=mean(len)) %>% 
  ggplot(aes(x=supp,y=meanlen, fill= supp))+
  geom_bar(stat = "identity")+
  geom_text(aes(label=round(meanlen, digits=1)), vjust=4,colour="white",size=5)+
  ylab("Means of len")+
  theme(legend.position = "none")

c<-ToothGrowth %>% group_by(dose) %>% summarise(meanlen=mean(len)) %>% 
  ggplot(aes(x=dose,y=meanlen, fill= dose))+
  geom_bar(stat = "identity")+
  geom_text(aes(label=round(meanlen, digits=1)), vjust=4,colour="white",size=4)+
  ylab("Means of len")+
  theme(legend.position = "none")

b<-ToothGrowth %>% group_by(supp,dose) %>% summarise(meanlen=mean(len)) %>% 
  ggplot(aes(x=dose,y=meanlen, fill=supp))+
  geom_bar(stat = "identity")+
  facet_wrap(~supp)+
  geom_text(aes(label=round(meanlen, digits=1)),
            vjust=2,colour="white",size=3)+
  ylab("Means of len")+
  theme(legend.position = "none")

grid.arrange(a,c,b, nrow = 2, top= textGrob("Summary of means",
                                            gp= gpar(fontsize=16)))

sdOJ <- sd(ToothGrowth$len[ToothGrowth$supp == "OJ"])
sdVC <- sd(ToothGrowth$len[ToothGrowth$supp == "VC"])
se <- sqrt((sdOJ^2/30)+(sdVC^2/30))
meanOJ <- mean(ToothGrowth$len[ToothGrowth$supp == "OJ"])
meanVC <- mean(ToothGrowth$len[ToothGrowth$supp == "VC"])
difOJ_VC <- meanOJ-meanVC

freedom <- function(s_x=1, s_y=1, n_x, n_y){
  p <- ((s_x^2/n_x) + (s_y^2/n_y))^2 / (((s_x^2/n_x)^2 /(n_x-1)) + ((s_y^2/n_y)^2 /(n_y-1)))
  print(p)
}
dfsupp <- freedom(sdOJ,sdVC,30,30)

difOJ_VC+c(-1,1)*qt(.975,df = dfsupp)*se

pt(difOJ_VC/se,58,lower.tail = FALSE)*2

t.test(ToothGrowth$len[ToothGrowth$supp== "OJ"],
       ToothGrowth$len[ToothGrowth$supp== "VC"],
       paired = FALSE,
       alternative = "two.sided",
       var.equal = FALSE,
       conf.level = .95)

t1<-t.test(ToothGrowth$len[ToothGrowth$dose== 0.5],
           ToothGrowth$len[ToothGrowth$dose== 1],
           paired = FALSE,
           alternative = "two.sided",
           var.equal = FALSE,
           conf.level = .95)$p.value

std0.5<- sd(ToothGrowth$len[ToothGrowth$dose== 0.5])
std1.0<- sd(ToothGrowth$len[ToothGrowth$dose== 1])
spool0.5_1.0 <- sqrt((std0.5^2*20-1+std1.0^2*20-1)/(20+20-2))
delta0.5_1.0 <- mean(ToothGrowth$len[ToothGrowth$dose==0.5])-mean(ToothGrowth$len[ToothGrowth$dose== 1])
p1 <- power.t.test(n=20,
                   delta = delta0.5_1.0,
                   sd=spool0.5_1.0,
                   sig.level = 0.05,
                   type = "two.sample",
                   alternative = "two.sided")$power

t2<-t.test(ToothGrowth$len[ToothGrowth$dose== 1],
           ToothGrowth$len[ToothGrowth$dose== 2],
           paired = FALSE,
           alternative = "two.sided",
           var.equal = FALSE,
           conf.level = .95)$p.value

td1.0<- sd(ToothGrowth$len[ToothGrowth$dose== 1])
std2.0<- sd(ToothGrowth$len[ToothGrowth$dose== 2])
spool1.0_2.0 <- sqrt((std1.0^2*20-1+std2.0^2*20-1)/(20+20-2))
delta1.0_2.0 <- mean(ToothGrowth$len[ToothGrowth$dose==1])-mean(ToothGrowth$len[ToothGrowth$dose== 2])
p2 <- power.t.test(n=20,
                   delta = delta1.0_2.0,
                   sd=spool1.0_2.0,
                   sig.level = 0.05,
                   type = "two.sample",
                   alternative = "two.sided")$power

