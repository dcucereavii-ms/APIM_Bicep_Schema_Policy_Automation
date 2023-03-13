// ****************************************
// Azure Bicep main template
// This bicep template demonstrates publishing an existing API end-point to an existing API maangement instance.
// The example illustrates using the "existing" term for an exisitng resource and then also importing an API end-point with OpenDocs specificatons to API management
// ****************************************
//refer to existing APIM
targetScope = 'resourceGroup'


//required parameters
param apimServiceName string  // need to be provided since it is existing
//param apimRG string //resource group of existing APIM instance
param apiPath string

@allowed([
  'openapi'
  'openapi+json'
  'openapi+json-link'
  'swagger-json'
  'swagger-link-json'
  'wadl-link-json'
  'wadl-xml'
  'wsdl'
  'wsdl-link'
])
@description('Type of OpenAPI we are importing')

param apiFormat string


var apiSpec = loadTextContent('../Schemas/swagger.json')
var xmlPolicy = loadTextContent('../Policies/policy.xml')
resource apimServiceName_colours_api_rev_1 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/colours-api;rev=1'
  properties: {
    description: 'Colours API'
    authenticationSettings: {
      subscriptionKeyRequired: false
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    apiRevision: '1'
    subscriptionRequired: true
    displayName: 'Colours API'
    serviceUrl: 'https://markcolorapi.azurewebsites.net/'
    path: apiPath
    format: apiFormat
    value: apiSpec
    protocols: [
      'https'
    ]
  }
  dependsOn: []
}

resource apimServiceName_colours_api_rev_1_policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  parent: apimServiceName_colours_api_rev_1
  name: 'policy'
  properties: {
    value: xmlPolicy
    format: 'rawxml'
  }
}
