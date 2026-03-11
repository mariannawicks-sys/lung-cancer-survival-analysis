
# Lung Cancer Survival Analysis
# Kaplan-Meier survival curves and Cox proportional hazards model

library(tidyverse)
library(survival)
library(survminer)
library(broom)

# Load dataset
lung_cancer_dataset <- read.csv("data/lung_cancer_dataset.csv")

# Create survival status variable (1 = death, 0 = alive)
lung_cancer_dataset$status <- ifelse(lung_cancer_dataset$Survived == "No", 1, 0)

# Create survival object
surv_object <- Surv(
  time = lung_cancer_dataset$Survival_Months,
  event = lung_cancer_dataset$status
)

# Kaplan-Meier model
km_fit <- survfit(
  surv_object ~ Cancer_Stage,
  data = lung_cancer_dataset
)

# Plot survival curves
ggsurvplot(
  km_fit,
  data = lung_cancer_dataset,
  pval = TRUE,
  conf.int = TRUE,
  risk.table = TRUE,
  xlab = "Survival Time (Months)",
  ylab = "Overall Survival Probability",
  title = "Kaplan-Meier Survival by Cancer Stage"
)

# Cox proportional hazards model
cox_model <- coxph(
  surv_object ~ Cancer_Stage + Age + Gender,
  data = lung_cancer_dataset
)

summary(cox_model)

# Check proportional hazards assumptionS
cox.zph(cox_model)
# ------------------------------
# Survival Analysis by Smoking Status
# ------------------------------

# Kaplan-Meier survival model by smoking status
km_smoking <- survfit(
  surv_object ~ Smoking_Status,
  data = lung_cancer_dataset
)

# Plot survival curves
ggsurvplot(
  km_smoking,
  data = lung_cancer_dataset,
  pval = TRUE,
  conf.int = TRUE,
  risk.table = TRUE,
  xlab = "Survival Time (Months)",
  ylab = "Overall Survival Probability",
  title = "Kaplan-Meier Survival by Smoking Status"
)

# Cox model adjusting for age and stage
cox_smoking <- coxph(
  surv_object ~ Smoking_Status + Age + Cancer_Stage,
  data = lung_cancer_dataset
)

summary(cox_smoking)
