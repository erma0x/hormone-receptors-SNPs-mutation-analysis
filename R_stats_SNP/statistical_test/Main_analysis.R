
# file path
data_path ="/home/jhon-smith/Desktop/Tirocinio/Tirocinio/ML_python/functionalElementDataARBindingProstate.csv"

# read csv
data.final<-data.frame(read.csv(data_path))

# summary stats
summary(data.final)

# Print NAN Count Values
sapply(data.final, function(x) sum(is.na(x))) 
# Print UNIQUE Values
sapply(data.final, function(x) length(unique(x))) 

# count columns
ncol(data.final)
# number of rows
nrow(data.final) 

# show dataframe
head(data.final,5)
# drop:  n_experiment, file_type, RS_ID
data.final <- subset(data.final,select=c(2,3,4,5,6,7,8,11,12,13))

# show structure
str(data.final)

# drop nan
data.final <- data.final[!is.na(data.final),]

# data manipulation

# find all cell lines
cell_line<-unique(data.final$cell_line)
cell_line
# associate each cell line to a number
data.final$cell_line<-as.factor(as.numeric(c("prostate" = "1", "PC-3" = "2","prostate gland" = "3",
                                   "22Rv1" = "4","C4-2B"="5","epithelial cell of prostate"="6",
                                   "LNCaP clone FGC"="7","VCaP"="8","RWPE1"="9","LNCAP"="10","RWPE2"="11"
                                    ))[data.final$cell_line])

# find all functional elements
FE<-unique(data.final$functional_element)
FE
# associate each functional element to a number
fe_features= c("H3K36me3-human" = "1", "EZH2-human" = "2","H3K27me3-human" = "3",
               "EP300-human" = "4","CTCF-human"="5","H3K27ac-human"="6",
               "H3K4me3-human"="7","H3K4me1-human"="8","H3K4me2-human"="9",
               "H3K79me2-human"="10","H3K9ac-human"="11",
               "H4K20me1-human"="12","POLR2AphosphoS5-human"="13","ZFX-human"="14","H2AFZ-human"="15",
               "H3F3A-human"="16","H3K9me3-human"="17","EZH2phosphoT487-human"="18","H3K9me2-human"=19)

str(fe_features)
# transform functional_element in numeric data
data.final$functional_element<-as.factor(as.numeric(fe_features)[data.final$functional_element])
# transform cancer_type in numeric data
data.final$cancer_type <- as.numeric(c("prostate" = "2"," " = "1")[data.final$cancer_type])
# transform cell_line_cancer in numeric data
data.final$cell_line_cancer <- as.numeric(c("cancer"="2","normal"="1")[data.final$cell_line_cancer])
# transform chr X in 23
levels(data.final$chr) <- c(levels(data.final$chr), "23")
data.final$chr[data.final$chr == 'X'] <- '23'
# transform chr Y in 24
levels(data.final$chr) <- c(levels(data.final$chr), "24")
data.final$chr[data.final$chr == 'Y'] <- '24'
# transform ref/alt as factor
data.final$ref<-as.factor(as.numeric(c("A" = "1", "T" = "2","C" = "3", "G" = "4")[data.final$ref]))
data.final$alt<-as.factor(as.numeric(c("A" = "1", "T" = "2","C" = "3", "G" = "4")[data.final$alt]))
# transform score
data.final$scoreA<-as.numeric(data.final$scoreA)
data.final$scoreB<-as.numeric(data.final$scoreB)
# pos
data.final$pos<-as.numeric(data.final$pos)
# omit nan values
data.final <- na.omit(data.final)
# extract features names
features<-names(data.final)
# extract chromosomes
chr_names<-names(data.final$chr)
head(data.final)
# show structure
str(data.final)
##################################################
# Chi squared cancer_type vs functional_element
data<-table(data.final$cancer_type,data.final$functional_element)
print(data)
print(chisq.test(data))
# p-value < 2.2e-16 ->  the cancer_type factor is dependent from functional_element

#################################################
# Chi squared cancer_type vs alt (alternative nucleotide)
data<-table(data.final$cancer_type, data.final$alt)
print(data)
print(chisq.test(data))
# the alternative nucleotide is not indipendent from the cancer_type variable

################################################
# fischer exact test cancer_type vs cell_line_cancer
data<-table(data.final$cancer_type, data.final$cell_line_cancer)
print(data)
print(fisher.test(data)) # 2x2 table input
# p_value<alpha ==> x,y aren't indipendent

###################################################
# model <- lm( functional_element+chr+pos~ cancer_type ,data=data.final)
model_aov <- aov( cancer_type ~ scoreA+cell_line+functional_element , data = data.final)
summary(model_aov)
# Test di Tukeys
getwd()
setwd('Desktop/Tirocinio/Tirocinio/R_scripts/statistical_tests/')

# funcions from Agricolae library
source('agricolae_extract/tapply.stat.R')
source('agricolae_extract/orderPvalue.R')
source('agricolae_extract/lastC.R')
source('agricolae_extract/HSD.test.R')

print(model_aov)
shapiro.test(sample(data.final$scoreA,100)) # non normal data

# Tukey test
#print(HSD.test(model_aov, 'cancer_type', group=F,console = T ,alpha = 0.01))


## PLOTTING ######################################
# plot SNPS count for each position found
# distinguish id the position in inside the coding gene region or not
# is important to assign the right chromosome for each gene
###################################################
op <- par(mar = c(1,8,0.3,0.1) + 5)

dfplot<-subset(data.final, data.final$chr!='X' & data.final$chr!='Y')
dfplot$chr[dfplot$chr == "23"]  <- "X"
dfplot$chr[dfplot$chr == "24"]  <- "Y"

barplot(table(droplevels(dfplot$chr)), main=" SNPs in chromosome ", sub = " count SNPs", horiz=F,
        names.arg=names(chr_names) , las = 1, cex.axis =0.8 )
box()
par(op)
###################################################
# PLOTTING
plot.new()
## margin for side 2 is 7 lines in size
op <- par(mar = c(1,8,0.3,0.1) + 4)
barplot(table(data.final$functional_element),main=" Functional Elements ", sub = " count SNPs", horiz=T,
        names.arg=names(fe_features) , las = 1, cex.axis =0.8 )
box()
par(op)
###################################################
op <- par(mar = c(1,8,0.3,0.1) + 5)
barplot(table(data.final$cancer_type), main=" Cancer Type ", horiz=F, las=1,
        names.arg=c("None", "Prostate"), col = c("brown","black"), sub = " count SNPs")
box()
par(op)
##################################################
pos_min =151656691    # start ESR1 
pos_max =152129619    # stop ESR1
pos_plot <- subset(data.final,
                   cancer_type==1 &
                   pos > pos_min & 
                   pos < pos_max &
                   chr == 6, # Chromosome
                   select = "pos" )
str(pos_plot)
pos_plot$pos<-sort(pos_plot$pos)
op <- par(mar = c(1,8,0.3,1) + 6)
barplot(table(pos_plot), main=" SNPs in ESR1 ", horiz=T, las=1,
         sub = " counts ",col = 'blue')
legend(4, 21,bty = 'n', legend=c("in the gene"),
       fill=c("blue"), cex=1)
par(op)
# Found 2 SNPs in Androgen Receptor coding region

#################################################
pos_start_gene = 67544021
pos_stop_gene = 67730619

pos_min = pos_start_gene - 500000 # start AR
pos_max = pos_stop_gene + 500000 # stop AR

pos_plot <- subset(data.final,
                    cancer_type==2 & # prostate
                    cell_line_cancer==1 & # normal 
                    pos > pos_min & 
                    pos < pos_max &
                    chr == 23,
                    select = c("pos") )
str(pos_plot)
pos_plot$pos<-sort(pos_plot$pos)
op <- par(mar = c(1,0.2,0.2,0.1) + 6)

colors_ = c(ifelse(((pos_plot$pos < pos_stop_gene & pos_plot$pos > pos_start_gene )) ,'blue','green' ))

barplot(table(pos_plot), xlab =  "count SNPs", horiz=T, las=1, col = colors_)
title(main=" SNPs count in Androgen Receptor region ",sub = 'for each position' )
par(op)
legend(1.5, 4,bty = 'n', legend=c("in the gene", "out of the gene"),
       fill=c("blue", "green"), cex=1)
# Found 2 SNPs in Androgen Receptor coding region 

#################################
#  PGR 

pos_start_gene=101029624
pos_stop_gene=101129813

pos_min = pos_start_gene - 1100000
pos_max = pos_stop_gene + 1100000

pos_plot <- subset(data.final,
                   cancer_type==1 & # prostate
                     cell_line_cancer==1 & # normal 
                     pos > pos_min & 
                     pos < pos_max &
                     chr == 11, # chromosome
                   select = c("pos") )
str(pos_plot)
pos_plot$pos<-sort(pos_plot$pos)
op <- par(mar = c(1,0.2,0.2,0.3) + 7)
colors_ = c(ifelse(((pos_plot$pos < pos_stop_gene & pos_plot$pos > pos_start_gene )) ,'blue','green' ))

barplot(table(pos_plot), xlab =  "count SNPs", horiz=T, las=1, col = colors_)
title(main=" SNPs count in Progesterone Receptor region ",sub = 'for each position' )

legend(1.5, 8,bty = 'n', legend=c("in the gene", "out of the gene"),
       fill=c("blue", "green"), cex=1)
par(op)
###################################################
# GR
plot.new()
pos_start_gene<-143277931
pos_stop_gene<-143435512


pos_min = pos_start_gene - 300000
pos_max = pos_stop_gene + 300000

pos_plot <- subset(data.final,
                     cancer_type==2 & # prostate
                     cell_line_cancer==1 & # normal 
                     pos > pos_min & 
                     pos < pos_max &
                     chr ==5,
                    
                        # Option, only outside the gene:
                        #(pos > pos_stop_gene | pos <pos_start_gene) 
                   select = c("pos") )
str(pos_plot)
pos_plot$pos<-sort(pos_plot$pos)
op <- par(mar = c(1,0.2,0.2,0.1) + 8)
colors_ = c(ifelse(((pos_plot$pos <= pos_stop_gene & pos_plot$pos >= pos_start_gene )),'blue','green' ))

barplot(table(pos_plot), xlab =  "count SNPs", horiz=T, las=1, col = colors_)
title(main=" SNPs count in Glucocorticoid Receptor region ",sub = 'for each position' )
par(op)
legend("topright",'groups', bty = 'n', legend=c("in the gene", "out of the gene"),
       fill=c("blue", "green"), cex=1)

