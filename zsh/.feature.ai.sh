##################################################
# GitHub Copilot CLI
##################################################
# Copilot CLI has no global "allow" config (permissions-config.json is
# per-repo only), so reduce approval prompts globally via CLI flags on
# every launch. Conservative set: read-only git + common npm test/build.
# Anything else (writes, rm, other shell, arbitrary URLs) still prompts.
copilot() {
  # Keep the portable baseline (dirs/tools/domains) fresh in
  # ~/.copilot/permissions-config.json, ~/.copilot/settings.json, and
  # ai/antigravity-settings.json (see ai/ai-permissions-seed.json).
  # Idempotent and fast; failures never block the actual launch.
  python3 ~/.dotfiles/ai/sync-ai-permissions.py >/dev/null 2>&1 || true

  command copilot \
    --allow-tool='shell(git status)' \
    --allow-tool='shell(git diff)' \
    --allow-tool='shell(git log)' \
    --allow-tool='shell(git show)' \
    --allow-tool='shell(git branch)' \
    --allow-tool='shell(npm test)' \
    --allow-tool='shell(npm run build)' \
    --allow-tool='shell(npm run lint)' \
    "$@"
}
