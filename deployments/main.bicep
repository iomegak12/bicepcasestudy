param location string = resourceGroup().location
param environmentName string = 'simplwebapi'

param containerImage string
param containerPort int
param registry string
param registryUsername string

@secure()
param registryPassword string

module law 'law.bicep' = {
  name: 'log-analytics-workspace'
  params: {
    name: 'law-${environmentName}'
    location: location
  }
}

module environment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    name: environmentName
    location: location
    lawClientId: law.outputs.clientId
    lawClientSecret: law.outputs.clientSecret
  }
}

module containerApp 'containerapp.bicep' = {
  name: 'ca-${environmentName}'
  params: {
    name: 'ca-${environmentName}'
    location: location
    environmentId: environment.outputs.id
    containerImage: containerImage
    containerPort: containerPort
    environmentVariables: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Production'
      }
    ]
    useExternalIngress: true
    registry: registry
    registryUsername: registryUsername
    registryPassword: registryPassword
  }
}

output fqdn string = containerApp.outputs.fqdn
