const cdk = require('@aws-cdk/core')
const budgets = require('@aws-cdk/aws-budgets')

class BudgetStack extends cdk.Stack {
    constructor(scope, id, vpcStack, props) {
        super(scope, id, props)

        new budgets.CfnBudget(this, 'Budget', {
            budget: {
                budgetLimit: {
                    amount: 1000,
                    unit: 'USD'
                },
                budgetType: 'COST',
                timeUnit: 'MONTHLY',
                costFilters: {
                    Service: [
                        'Amazon Elastic Compute Cloud - Compute',
                        'Amazon Elastic Block Store'
                    ],
                    TagKeyValue: [
                        'user:Application$MyApp'
                    ]
                }
            },
            notificationsWithSubscribers: [{
                notification: {
                    comparisonOperator: 'GREATER_THAN',
                    notificationType: 'ACTUAL',
                    threshold: 80,
                    thresholdType: 'PERCENTAGE'
                },
                subscribers: [{
                    subscriptionType: 'EMAIL',
                    address: 'my@email.com'
                }]
            }]
        })
    }
}

const app = new cdk.App()
new BudgetStack(app, 'BudgetStack')