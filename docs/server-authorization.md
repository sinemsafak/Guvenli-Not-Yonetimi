# GÜVENLİ NOT OKUMA

FUNCTION GET_NOTE(request, noteId):

    # 1. Kimlik doğrulama
    session = VERIFY_ACCESS_TOKEN(request.authorization)

    IF session is INVALID:
        RETURN 401 Unauthorized

    # userId istemci gövdesinden alınmaz.
    authenticatedUserId = session.subject

    # 2. Kullanıcı ve rol bilgisini güvenilir kaynaktan al
    user = DATABASE.findUser(authenticatedUserId)

    IF user does not exist:
        RETURN 401 Unauthorized

    # 3. İstenen notu veritabanından getir
    note = DATABASE.findNote(noteId)

    IF note does not exist:
        RETURN 404 Not Found

    # 4. Yönetici politikası
    IF user.role == ADMIN:

        permission = AUTHORIZATION.checkPermission(
            user,
            "notes:read:any"
        )

        businessPurpose = POLICY.checkBusinessPurpose(
            request,
            note
        )

        IF permission is false OR businessPurpose is false:
            RETURN 404 Not Found

        RETURN 200 OK WITH note

    # 5. Normal kullanıcı sahiplik kontrolü
    IF note.ownerId != authenticatedUserId:
        RETURN 404 Not Found

    # 6. Yetki doğrulandı
    RETURN 200 OK WITH note


# GÜVENLİ NOT SİLME

FUNCTION DELETE_NOTE(request, noteId):

    session = VERIFY_ACCESS_TOKEN(request.authorization)

    IF session is INVALID:
        RETURN 401 Unauthorized

    authenticatedUserId = session.subject

    user = DATABASE.findUser(authenticatedUserId)

    IF user does not exist:
        RETURN 401 Unauthorized

    note = DATABASE.findNote(noteId)

    IF note does not exist:
        RETURN 404 Not Found

    IF user.role == ADMIN:

        IF NOT AUTHORIZATION.checkPermission(
            user,
            "notes:delete:any"
        ):
            RETURN 403 Forbidden

        IF NOT POLICY.checkBusinessPurpose(request, note):
            RETURN 403 Forbidden

    ELSE:

        IF note.ownerId != authenticatedUserId:
            RETURN 404 Not Found

    DATABASE.deleteNote(note.id)

    RETURN 204 No Content


# KULLANICI ROLÜ DEĞİŞTİRME

FUNCTION CHANGE_USER_ROLE(request, targetUserId, newRole):

    session = VERIFY_ACCESS_TOKEN(request.authorization)

    IF session is INVALID:
        RETURN 401 Unauthorized

    actor = DATABASE.findUser(session.subject)

    IF actor does not exist:
        RETURN 401 Unauthorized

    IF actor.role != ADMIN:
        RETURN 403 Forbidden

    IF NOT AUTHORIZATION.checkPermission(
        actor,
        "users:role:update"
    ):
        RETURN 403 Forbidden

    IF NOT POLICY.isAllowedRoleTransition(actor, newRole):
        RETURN 403 Forbidden

    target = DATABASE.findUser(targetUserId)

    IF target does not exist:
        RETURN 404 Not Found

    DATABASE.updateRole(targetUserId, newRole)

    AUDIT.log(
        actorId = actor.id,
        action = "USER_ROLE_CHANGED",
        targetId = targetUserId
    )

    RETURN 200 OK