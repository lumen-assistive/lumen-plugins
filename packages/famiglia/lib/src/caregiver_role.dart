/// What a paired caregiver is allowed to do.
enum CaregiverRole {
  /// Can view the shared calendar and daily status, but cannot change
  /// any configuration.
  viewer,

  /// Can view the shared calendar and daily status, receive alerts, and
  /// change module configuration on the user's behalf.
  manager,
}

/// An action a caregiver may be allowed to perform.
enum CaregiverAction {
  /// Viewing the shared calendar.
  viewCalendar,

  /// Receiving alerts about the user's status.
  receiveAlerts,

  /// Changing module configuration remotely.
  modifyConfig,
}

const Map<CaregiverRole, Set<CaregiverAction>> _allowedActions = {
  CaregiverRole.viewer: {
    CaregiverAction.viewCalendar,
    CaregiverAction.receiveAlerts,
  },
  CaregiverRole.manager: {
    CaregiverAction.viewCalendar,
    CaregiverAction.receiveAlerts,
    CaregiverAction.modifyConfig,
  },
};

/// Whether [role] is allowed to perform [action].
bool caregiverRoleAllows(CaregiverRole role, CaregiverAction action) {
  return _allowedActions[role]?.contains(action) ?? false;
}
