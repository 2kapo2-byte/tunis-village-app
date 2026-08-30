enum PartnerBookingOperation { create, view, updateStatus }

enum PartnerBookingResultStatus {
  success,
  notAuthenticated,
  notApproved,
  notAuthorized,
  invalidTransition,
  unavailable,
  unknown,
}

PartnerBookingResultStatus partnerBookingResultStatusFromError(String? value) {
  switch (value?.toLowerCase()) {
    case 'not_authenticated': return PartnerBookingResultStatus.notAuthenticated;
    case 'partner_not_approved': return PartnerBookingResultStatus.notApproved;
    case 'not_authorized': return PartnerBookingResultStatus.notAuthorized;
    case 'invalid_transition': return PartnerBookingResultStatus.invalidTransition;
    case 'unit_unavailable': return PartnerBookingResultStatus.unavailable;
    default: return PartnerBookingResultStatus.unknown;
  }
}
