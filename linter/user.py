import typing as t

from sqlmesh.core.linter.rule import Rule, RuleViolation
from sqlmesh.core.model import Model

# Approved tags — each carries its own linter checks (see rules below).
# 'standard' is the escape hatch for models that don't need stricter checks.
APPROVED_TAGS = {"critical", "pii", "finance", "standard"}
BUILTIN_AUDITS = {
    "not_null",
    "unique_values",
    "accepted_values",
    "number_of_rows",
    "forall",
    "has_import",
}


class RequireApprovedTag(Rule):
    """Model must declare at least one approved tag: critical, pii, finance, standard."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        model_tags = set(model.tags or [])
        if not model_tags & APPROVED_TAGS:
            return self.violation(
                f"Model must have at least one of: {', '.join(sorted(APPROVED_TAGS))}"
            )
        return None


class NoMissingOwner(Rule):
    """Model owner should always be specified."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        return self.violation() if not model.owner else None


class RequireDescription(Rule):
    """Model description should always be specified."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        return self.violation() if not model.description else None


class RequireBuiltinAudit(Rule):
    """Model must include at least one built-in audit (not_null, unique_values, accepted_values, etc.)."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        audit_names = {name.lower() for name, _ in model.audits}
        has_builtin = bool(audit_names & BUILTIN_AUDITS)
        if not has_builtin:
            return self.violation(
                f"No built-in audit found. Add at least one of: {', '.join(sorted(BUILTIN_AUDITS))}"
            )
        return None


class CriticalModelsRequireAudits(Rule):
    """Models tagged 'critical' must have both not_null and unique_values audits."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        if "critical" not in (model.tags or []):
            return None
        audit_names = {name.lower() for name, _ in model.audits}
        missing = {"not_null", "unique_values"} - audit_names
        if missing:
            return self.violation(
                f"Models tagged 'critical' must include: {', '.join(sorted(missing))}"
            )
        return None


class PIIModelsRequireOwner(Rule):
    """Models tagged 'pii' must declare an owner."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        if "pii" not in (model.tags or []):
            return None
        if not model.owner:
            return self.violation("Models tagged 'pii' must declare an owner.")
        return None


class FinanceModelsRequireGrain(Rule):
    """Models tagged 'finance' must declare a grain."""

    def check_model(self, model: Model) -> t.Optional[RuleViolation]:
        if "finance" not in (model.tags or []):
            return None
        if not model.grain:
            return self.violation("Models tagged 'finance' must declare a grain.")
        return None
