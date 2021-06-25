
TriggerJob.where(rule_type: "sqs_v2") do |job|

end

#後処理の検索
queue_name = "qa-ec2-02-002"
PostProcess.where(service: "sqs").find do |post_process|
  post_process.parameters["queue"] == queue_name
end
