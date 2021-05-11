
#verbs.sh AssetSecuritization
#verbs.sh AccountsReceivable
#verbs.sh ATMNetworkOperations
#verbs.sh BranchCurrencyDistribution
#verbs.sh BranchCurrencyManagement
#verbs.sh BranchLocationManagement
#verbs.sh BranchLocationOperations
#verbs.sh BusinessArchitecture
#verbs.sh CardCapture
#verbs.sh CentralCashHandling
#verbs.sh Collections

cp AssetSecuritization.yaml AccountsReceivable.yaml ATMNetworkOperations.yaml BranchCurrencyDistribution.yaml BranchCurrencyManagement.yaml BranchLocationManagement.yaml BranchLocationOperations.yaml BusinessArchitecture.yaml CardCapture.yaml Collections.yaml wave5/
cd wave5
git add .
git commit -m "Awesome BIAN APIs"
git push -u origin master