param name string
param location string
param environmentId string
param containerImage string
param useExternalIngress bool = false
param containerPort int

param registry string
param registryUsername string

@secure()
param registryPassword string

param environmentVariables array = []

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: name
  location: location
  kind: 'containerapp'
  properties: {
    kubeEnvironmentId: environmentId
    configuration: {
      secrets: [
        {
          name: 'container-registry-password'
          value: registryPassword
        }
      ]
      registries: [
        {
          server: registry
          username: registryUsername
          passwordSecretRef: 'container-registry-password'
        }
      ]
      ingress: {
        external: useExternalIngress
        targetPort: containerPort
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: name
          env: environmentVariables
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn


