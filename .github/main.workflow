workflow "Push" {
  on = "push"
  resolves = ["Draft Release"]
}

action "Draft Release" {
  uses = "toolmantim/release-drafter@v5.1.1"
  secrets = ["GITHUB_TOKEN"]
}
