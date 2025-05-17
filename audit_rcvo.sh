#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Audit complet — $(date)"

# 1) Install & lint
if [ -f package.json ]; then
  echo "→ npm ci"; npm ci
  echo "→ npm run lint"; npm run lint
fi

# 2) Tests unitaires & d’intégration
if grep -q "test:integration" package.json; then
  echo "→ npm test"; npm test
  echo "→ npm run test:integration"; npm run test:integration
else
  echo "ℹ️ Pas de script test:integration détecté"
fi

# 3) Cypress E2E
if [ -d cypress ]; then
  echo "→ Cypress E2E"; npx cypress run || echo "⚠️ Échecs Cypress"
else
  echo "ℹ️ Pas de répertoire cypress"
fi

# 4) Helm & Terraform
if [ -d infra/helm ]; then
  echo "→ helm lint infra/helm"; helm lint infra/helm
else
  echo "ℹ️ Pas de chart Helm détecté"
fi

if [ -d infra/terraform ]; then
  echo "→ terraform validate infra/terraform"
  cd infra/terraform && terraform init -backend=false && terraform validate && cd - >/dev/null
else
  echo "ℹ️ Pas de dossier infra/terraform"
fi

# 5) Statut des migrations
if grep -q "migrate:status" package.json; then
  echo "→ npm run migrate:status"; npm run migrate:status || echo "ℹ️ Vérifie tes migrations"
fi

echo "✅ Audit terminé — $(date)"
