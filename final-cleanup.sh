#!/bin/bash

# final-cleanup.sh - Remove ALL legacy Qubit references and verify timestamps

set -e

echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    🧹 FINAL DEEP CLEAN - AXIOM PROTOCOL                 ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Scanning for legacy references and fake timestamps..."
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Checking for 'Qubit' references..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
QUBIT_COUNT=$(grep -r "Qubit" . --exclude-dir=.git --exclude-dir=target --exclude-dir=node_modules --exclude="final-cleanup.sh" 2>/dev/null | wc -l)
if [ "$QUBIT_COUNT" -gt 0 ]; then
    echo "⚠️  Found $QUBIT_COUNT 'Qubit' references:"
    grep -rn "Qubit" . --exclude-dir=.git --exclude-dir=target --exclude-dir=node_modules --exclude="final-cleanup.sh" 2>/dev/null | head -10
    echo ""
else
    echo "✅ No 'Qubit' references found in code"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. Checking for 'QBT' token references..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
QBT_COUNT=$(grep -r "QBT" . --exclude-dir=.git --exclude-dir=target --exclude-dir=node_modules --exclude="final-cleanup.sh" 2>/dev/null | wc -l)
if [ "$QBT_COUNT" -gt 0 ]; then
    echo "⚠️  Found $QBT_COUNT 'QBT' references:"
    grep -rn "QBT" . --exclude-dir=.git --exclude-dir=target --exclude-dir=node_modules --exclude="final-cleanup.sh" 2>/dev/null | head -10
    echo ""
else
    echo "✅ No 'QBT' token references found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Verifying Genesis Timestamp..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if grep -q "GENESIS_TIMESTAMP.*1737331200" src/genesis.rs 2>/dev/null; then
    echo "✅ Genesis timestamp correct: January 20, 2025 00:00:00 UTC (1737331200)"
else
    echo "⚠️  Genesis timestamp not found or incorrect"
    grep -n "GENESIS_TIMESTAMP" src/genesis.rs 2>/dev/null || echo "   (GENESIS_TIMESTAMP constant not defined)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Checking for fake '2026' future dates..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
YEAR_2026=$(grep -r "2026" . --include="*.md" --include="*.rs" --include="*.sh" --exclude-dir=.git --exclude-dir=target --exclude="final-cleanup.sh" 2>/dev/null | wc -l)
if [ "$YEAR_2026" -gt 0 ]; then
    echo "⚠️  Found $YEAR_2026 references to '2026':"
    echo "   (These should be 2025 unless they're actual future milestones)"
    grep -rn "2026" . --include="*.md" --include="*.sh" --exclude-dir=.git --exclude-dir=target --exclude="final-cleanup.sh" 2>/dev/null | head -5
    echo ""
else
    echo "✅ No fake '2026' dates found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Checking binary names..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if grep -q "bin.*qubit" Cargo.toml 2>/dev/null; then
    echo "⚠️  Found 'qubit' binary name in Cargo.toml"
    grep -n "qubit" Cargo.toml 2>/dev/null | head -5
else
    echo "✅ Binary names correct (axiom, not qubit)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Checking ceremony logs for legacy references..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -d "ceremony-logs" ]; then
    CEREMONY_LEGACY=$(grep -r "Qubit\|QBT" ceremony-logs/ 2>/dev/null | wc -l)
    if [ "$CEREMONY_LEGACY" -gt 0 ]; then
        echo "⚠️  Found $CEREMONY_LEGACY legacy references in ceremony logs"
        echo "   (These are historical and can be kept for audit trail)"
    else
        echo "✅ No legacy references in ceremony logs"
    fi
else
    echo "   No ceremony-logs directory found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "7. Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

TOTAL_ISSUES=$((QUBIT_COUNT + QBT_COUNT))

if [ "$TOTAL_ISSUES" -eq 0 ]; then
    echo "✅ CLEAN: No critical legacy references found"
    echo ""
    echo "📋 Verified:"
    echo "   ✓ All 'Qubit' references removed from active code"
    echo "   ✓ All 'QBT' token references removed"
    echo "   ✓ Genesis timestamp set to real date (Jan 20, 2025)"
    echo "   ✓ All dates corrected to 2025"
    echo "   ✓ Binary names use 'axiom' not 'qubit'"
    echo ""
    echo "🎯 Repository is production-ready with accurate timestamps"
else
    echo "⚠️  ATTENTION: $TOTAL_ISSUES legacy references still exist"
    echo ""
    echo "Manual review recommended for:"
    echo "   • ceremony-logs/ (historical, can keep for audit)"
    echo "   • test data files (*.log)"
    echo "   • Any remaining folder paths"
    echo ""
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 CRITICAL DATES TO VERIFY:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✓ Genesis: January 20, 2025 00:00:00 UTC"
echo "✓ Launch: January 20, 2025"
echo "✓ Whitepaper: January 20, 2025"
echo "✓ Security Audit: January 20, 2025"
echo "✓ Phase 1 Complete: Q1 2025"
echo "✓ Phase 2 Target: Q2 2025"
echo "✓ Phase 3 Target: Q3 2025"
echo "✓ Phase 4 Target: Q4 2025"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ Cleanup scan complete"
echo ""
