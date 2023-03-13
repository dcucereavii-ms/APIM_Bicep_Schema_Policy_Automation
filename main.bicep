param apimServiceName string
var apiSpec = loadTextContent('swagger.json')
var xmlPolicy = loadTextContent('policy.xml')
resource apimServiceName_sw_api_rev_1 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/sw;rev=1'
  properties: {
    description: 'Star Wars'
    authenticationSettings: {
      subscriptionKeyRequired: false
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    apiRevision: '1'
    subscriptionRequired: true
    displayName: 'Star Wars'
    serviceUrl: 'https://swapi.dev/api'
    path: 'sw'
    format: 'openapi+json'
    value: apiSpec
    protocols: [
      'https'
    ]
  }
  dependsOn: []
}

resource apimServiceName_sw_api_rev_1_policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  parent: apimServiceName_sw_api_rev_1
  name: 'policy'
  properties: {
    value: xmlPolicy
    format: 'rawxml'
  }
}
