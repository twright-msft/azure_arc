Start-Transcript -Path C:\tmp\pshs_cleanup.log

# Deleting Azure Arc Data Controller namespace and it's resources (PostgreSQL incl.)
start Powershell {for (0 -lt 1) {kubectl get pod -n $env:ARC_DC_NAME; sleep 5; clear }}
azdata login -n $env:ARC_DC_NAME
azdata arc postgres server delete -n $env:PSHS_NAME
kubectl delete clusterroles arcdatactrl:cr-arc-metricsdc-reader
kubectl delete clusterrolebindings arcdatactrl:crb-arc-metricsdc-reader
kubectl delete ns $env:ARC_DC_NAME

# Restoring State
Copy-Item -Path "C:\tmp\hosts_backup" -Destination "C:\Windows\System32\drivers\etc\hosts" -Recurse -Force -ErrorAction Continue
Copy-Item -Path "C:\tmp\settings_template_backup.json" -Destination "C:\tmp\settings_template.json" -Recurse -Force -ErrorAction Continue

Remove-Item "C:\Users\$env:adminUsername\AppData\Roaming\azuredatastudio\User\settings.json" -Force
Remove-Item "C:\tmp\hosts_backup" -Force
Remove-Item "C:\tmp\settings_template_backup.json" -Force

Stop-Transcript

Stop-Process -Name powershell -Force
