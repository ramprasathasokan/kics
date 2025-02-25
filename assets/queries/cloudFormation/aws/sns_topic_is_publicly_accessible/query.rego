package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SNS::TopicPolicy"

	policy := resource.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[j]
	common_lib.is_allow_effect(statement)
	common_lib.any_principal(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow actions from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows actions from all principals", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "PolicyDocument"], []),
	}
}
