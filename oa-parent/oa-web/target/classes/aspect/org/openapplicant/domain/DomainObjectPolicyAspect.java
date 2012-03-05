package org.openapplicant.domain;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.DeclareError;

@Aspect
public class DomainObjectPolicyAspect {
	
	@DeclareError(
			"call(* org.openapplicant.domain.DomainObject.beforeSave()) && " +
			"!withincode(* org.openapplicant.dao.hibernate.DomainObjectSaveOrUpdateListener.onSaveOrUpdate(..))"
	)
	public static final String errorMessage = 
		"beforeSave() should only be called within DomainObjectSaveOrUpdateListener.onSaveOrUpdate()";

}
