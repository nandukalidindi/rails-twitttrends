require 'aws-sdk'
require 'pry'

Aws.config.update({region: 'us-west-2',credentials:
Aws::Credentials.new('aws_access_key_id', 'aws_secret_access_key')})

c = Aws::SNS::Client.new(region: 'us-west-2')

resp = c.publish({
  topic_arn: "ARN",
  message: "{\"default\":\"SOMETHING\",\"email\":\"WHAT THE CRAP!!\"}",
  subject: "TEST SUBJECT",
  message_structure: "json",
  message_attributes: {
    # "default" => {
    #   data_type: "String",
    #   string_value: "SOMETHING!"
    # },
    "email" => {
      data_type: "String",
      string_value: "WOW!"
    }
  }
})
