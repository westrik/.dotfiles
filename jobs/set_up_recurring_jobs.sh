for time_period in "hourly" "daily" "weekly"; do
	ln -s "$HOME/.dotfiles/jobs/plists/westrik-job.$time_period.plist" "$HOME/Library/LaunchAgents/westrik-job.$time_period.plist"
	launchctl load "$HOME/Library/LaunchAgents/westrik-job.$time_period.plist"
	launchctl start "westrik-job.$time_period"
done
