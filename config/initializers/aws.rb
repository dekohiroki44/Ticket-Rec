ActionMailer::Base.add_delivery_method :ses,
                                       AWS::SES::Base,
                                       access_key_id: "AKIAX5LZT23PUXYSSVPH",
                                       secret_access_key: "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",
                                       server: 'email.us-west-2.amazonaws.com'