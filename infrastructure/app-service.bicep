param location string = resourceGroup().location
var appServicePlanName = 'asp-iw-appservice-slots'
var webAppName = 'app-iw-appservice-slots'
var sku = 'P0V3'
var linuxFxVersion = 'NODE|20-lts'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: true
      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'SCM_MAX_ZIP_PACKAGE_COUNT'
          value: '1' // keeping only the recent zip uploaded to app service
        }
      ]
    }
  }
}

resource appServiceSlot 'Microsoft.Web/sites/slots@2022-09-01' = {
  name: 'staging'
  location: location
  parent: appService
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: true
      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'SCM_MAX_ZIP_PACKAGE_COUNT'
          value: '1' // keeping only the recent zip uploaded to app service
        }
      ]
    }
  }
}


