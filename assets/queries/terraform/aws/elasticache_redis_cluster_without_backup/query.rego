package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	cluster.engine == "redis"
	not common_lib.valid_key(cluster, "snapshot_retention_limit")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": name,
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'snapshot_retention_limit' is higher than 0",
		"keyActualValue": "'snapshot_retention_limit' is undefined",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_elasticache_cluster[name]

	cluster.engine == "redis"
	cluster.snapshot_retention_limit = 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": name,
		"searchKey": sprintf("aws_elasticache_cluster[%s].snapshot_retention_limit", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'snapshot_retention_limit' is higher than 0",
		"keyActualValue": "'snapshot_retention_limit' is 0",
	}
}
