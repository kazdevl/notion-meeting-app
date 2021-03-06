package config

import "os"

func CORSAllowOrigin() string {
	return getterEnvInfo("CORS_ALLOW_ORIGIN")
}

func Port() string {
	return getterEnvInfo("PORT")
}

func DATABASE_URL() string {
	return getterEnvInfo("DATABASE_URL")
}

func SLACK_TOKEN() string {
	return getterEnvInfo("SLACK_TOKEN")
}

func SLACK_SECRET() string {
	return getterEnvInfo("SLACK_SECRET")
}

func WEBHOOK_URL() string {
	return getterEnvInfo("WEBHOOK_URL")
}

func ENCRYPTION_KEY() string {
	return getterEnvInfo("ENCRYPTION_KEY")
}

func getterEnvInfo(key string) string {
	return os.Getenv(key)
}
