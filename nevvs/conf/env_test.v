import os
import conf

const (
	stage = "test"
	file_path = os.getwd() + "/.env.$stage"
)

fn test_set_env_cfg() {
	result := conf.set_env_cfg(stage) or {panic("fail to set env config.")}

	assert os.getenv("RSS_URL") != ""
}
