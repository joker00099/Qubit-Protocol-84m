#!/bin/bash

# repo-cleanup.sh - Remove 70% of bloat from Axiom Protocol repository

set -e

echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║          🧹 AXIOM PROTOCOL REPOSITORY CLEANUP                            ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Starting cleanup: Reducing from ~80 files to ~30-35 files"
echo ""

# Count before
BEFORE=$(ls -1 | wc -l)
echo "📊 Files before: $BEFORE"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Delete demo validator folders (5 folders, ~50 files)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -rf demo-validator-1 demo-validator-2 demo-validator-3 demo-validator-4 demo-validator-5 2>/dev/null || echo "  Already removed"
echo "✅ Demo validators removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Delete redundant deployment scripts (keep only launch-mainnet.sh)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -f deploy-validator.sh deploy-all-validators.sh start-validator.sh stop-validator.sh 2>/dev/null || echo "  Some already removed"
git rm -f backup-validator.sh check-validator.sh validator-firewall.sh 2>/dev/null || echo "  Some already removed"
git rm -f launch-axiom-node.sh launch-demo.sh launch.sh 2>/dev/null || echo "  Some already removed"
echo "✅ Redundant deployment scripts removed (keeping launch-mainnet.sh)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Delete cloud provisioning scripts (not core blockchain)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -f provision-servers.sh auto-provision-aws.sh deploy-cloud-validators.sh 2>/dev/null || echo "  Already removed"
echo "✅ Cloud provisioning scripts removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4: Delete network diagnostic scripts (should be CLI commands)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -f network-diagnostics.sh network-status.sh 2>/dev/null || echo "  Already removed"
echo "✅ Network diagnostic scripts removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5: Delete duplicate documentation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -f DEPLOYMENT.md MAINNET-DEPLOYMENT.md VALIDATOR-GUIDE.md IMPLEMENTATION-COMPLETE.md 2>/dev/null || echo "  Some already removed"
echo "✅ Duplicate documentation removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 6: Delete auto-generated runtime files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -f deployment-info.txt mainnet-status.json 2>/dev/null || echo "  Already removed"
echo "✅ Auto-generated files removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 7: Delete duplicate configs (keep only config/)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git rm -f axiom-validator.service 2>/dev/null || echo "  Already removed"
echo "✅ Duplicate configs removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 8: Move scattered docs to docs/ folder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
mkdir -p docs 2>/dev/null
git mv ECONOMICS_TOKENOMICS.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv GOVERNANCE.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv LEGAL_COMPLIANCE.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv NETWORK_PROTOCOL.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv SECURITY_MODEL.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv TESTS_TODO.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv 124M-SOVEREIGN-SUPPLY-UPGRADE.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv ARCHITECTURE_DECISIONS.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv ATTACK_PATTERNS.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv COMPARISON.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv INTEGRATION_GUIDE.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
git mv WHITEPAPER_OUTLINE.md docs/ 2>/dev/null || echo "  Already moved or doesn't exist"
echo "✅ Documentation organized into docs/"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 9: Update .gitignore for runtime files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat >> .gitignore << 'GITIGNORE_END'

# Runtime generated files (do not commit)
deployment-info.txt
mainnet-status.json
validator-*.json
ai_stats.json
*.log

# Private keys (NEVER commit)
keys/
*.pem
wallet.dat

# Auto-generated configs
demo-validator-*/
GITIGNORE_END
echo "✅ .gitignore updated"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 10: Create scripts/ directory for remaining scripts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
mkdir -p scripts 2>/dev/null
git mv launch-mainnet.sh scripts/ 2>/dev/null || echo "  Already moved"
git mv final-cleanup.sh scripts/ 2>/dev/null || echo "  Already moved"
git mv repo-cleanup.sh scripts/ 2>/dev/null || echo "  Will be in scripts/"
echo "✅ Scripts organized into scripts/"

echo ""
# Count after
AFTER=$(ls -1 | wc -l)
DELETED=$((BEFORE - AFTER))
PERCENT=$((DELETED * 100 / BEFORE))

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ CLEANUP COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Results:"
echo "   Before: $BEFORE files/folders"
echo "   After: $AFTER files/folders"
echo "   Deleted: $DELETED files/folders ($PERCENT% reduction)"
echo ""
echo "📂 New Structure:"
echo "   ✓ src/ - Core blockchain code"
echo "   ✓ docs/ - All documentation"
echo "   ✓ scripts/ - Essential scripts only"
echo "   ✓ config/ - Configuration files"
echo "   ✓ Root: Core files only (Cargo.toml, README.md, etc.)"
echo ""
echo "🎯 Benefits:"
echo "   ✅ 70% less clutter"
echo "   ✅ Clear structure"
echo "   ✅ Faster onboarding"
echo "   ✅ Easier maintenance"
echo "   ✅ Professional appearance"
echo ""
echo "Next steps:"
echo "  git add -A"
echo "  git commit -m '🧹 Major cleanup: Remove $DELETED redundant files ($PERCENT% reduction)'"
echo "  git push origin main"
echo ""
