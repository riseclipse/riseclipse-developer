
- **`RiseClipseValidatorSCL.prepare()`**
  - `nsdValidator = new NsdValidator()`
    - `for each nsdFile:`
      - `nsdValidator.add(nsdFile)`
  - `nsdValidator.prepare()`
    - `nsdEObjectValidator = new NsdEObjectValidator()`
  - `for each sclFile:`
    - `nsdEObjectValidator.validate(sclFile)`

- **`NsdEObjectValidator.NsdEObjectValidator()`**
  - _# list of namespaces is ordered according to_ `dependsOn` _links, starting with root namespaces_
  - `for each namespace:`
    - _# There is only one map for all_ `TypeValidator`, _therefore_ `namespace` _is used in the key_
    - `TypeValidator.buildBasicTypeValidators(namespace)`
      - `for each basicType:`
        - _get the (predefined)_ `basicTypeValidator` _using_ `basicTy
        - _associate it to_ `(namespace, basicType)` _in_ `TypeValidatorMap`
    - `TypeValidator.builEnumerationdValidators(namespace)`
      - `for each enumeration:`
        - _associate a (constructed)_ `enumerationValidator` _to_ `(namespace, enumeration)` _in_ `TypeValidatorMap`
  - `for each namespace:`
    - `TypeValidator.buildConstructedAttributeValidators(namespace)`
      - `for each constructedAttribute:`
        - _associate a (constructed)_ `ConstructedAttributeValidator` _to_ `(namespace, constructedAttribute)` _in_ `TypeValidatorMap`
            
  - `for each namespace:`
    - _# There is only one map for all_ `CDCValidator`, _therefore_ `namespace` _is used in the key_
    - _# Because of parameterized CDC, the name of a CDC is not a key in a given namespace_
    - _# So, the cdc is used, and the_ `CDCImpl` _class ensures uniqueness of of parameterized CDC_
    - `for each cdc:`
      - `new CDCValidator(namespace, cdc)`
      - _associate it to_ `(namespace, cdc)` _in_ `CDCValidatorMap`
  - `for each namespace:`
    - _# There is only one map for all_ `LNClassValidator`, _therefore_ `namespace` _is used in the key_
    - _# The name of an_ `LNClass` _is a key in a given namespace_
    - `for each lnClass:`
      - `new LNClassValidator(namespace, lnClass)`
      - _associate it to_ `(namespace, lnClass.name)` _in_ `LNClassValidatorMap`

- **`ConstructedAttributeValidator.ConstructedAttributeValidator(namespace, constructedAttribute)`**
  - _build the corresponding `SubDataAttributePresenceConditionValidator`_
    - `for each subDataAttribute:`
      - _associate the presence condition and other details_
  - `for each subDataAttribute:`
    - _find the_ `TypeValidator` _of_ `subDataAttribute.type` _in_ `namespace` _(using_ `dependsOn` _links)_
    - _associate the validator to_ `subDataAttribute.name` _in_ `SubDataAttributeValidatorMap`


- **`CDCValidator.CDCValidator(namespace, cdc)`**
  - _build the corresponding_ `DataAttributePresenceConditionValidator`
    - `for each dataAttribute:`
      - _associate the presence condition and other details_
  - _build the corresponding_ `SubDataObjectPresenceConditionValidator`
    - `for each subDataObject:`
      - _associate the presence condition and other details_
  - `for each dataAttribute:`
    - _find the_ `TypeValidator` _of its type in_ `namespace` _(using_ `dependsOn` _links)_
    - _associate the found validator to_ `dataAttribute.name` _in_ `dataAttributeValidatorMap`
    - _find the_ `FunctionalConstraintValidator` _using_ `dataAttribute.fc` _# no namespace involved_
    - _associate the found validator to_ `dataAttribute.name` _in_ `functionalConstraintValidatorMap`
  - `for each subDataObject:`
    - _find the_ `CDCValidator` _of_ `(namespace, subDataObject.cdc)` _(using_ `dependsOn` _links)_
    - _associate the found validator to_ `subDataObject.name` _in_ `subDataObjectValidatorMap`

- **`LNClassValidator.LNClassValidator()`**
  - _build two_ `DataObjectPresenceConditionValidator` _(for statistical and not statistical_ `LNodeType`_)_
    - `for each dataObject:`
      - `associate the presence condition and other details`
  - `for each dataObject` _including inherited ones:_
    - _find the_ `CDCValidator` _of_ `(namespace, dataObject.cdc)` _(using_ `dependsOn` _links)_
    - _associate the found validator to_ `dataObject.name` _in_ `dataObjectValidatorMap`




- **`NsdEObjectValidator.validate()`**
  - `for each anyLN:`
    - _find_ `lnClassValidator` _in_ `LNClassValidatorMap` _for_ `(anyLN.namespace, anyLN.lnClass)`
    - `lnClassValidator.validateLNodeType(anyLN.lNodeType)`

- **`LNClassValidator.validateLNodeType(lNodeType)`**
  - `for each DO of the LNodeType:`
    - _if it has no namespace or if its namespace_ `dependsOn` _current_ `namespace:`
      - _tell its presence to the_ `DataObjectPresenceConditionValidator`
  - `DataObjectPresenceConditionValidator.validate()`
  - `for each DO of the LNodeType:`
    - _find_ `cdcValidator` _of_ `DO.name` _in_ `dataObjectValidatorMap`
    - `cdcValidator.validateDOType(DO.type)`

- **`CDCValidator.validateDOType(doType)`**
  - `for each DA of doType:`
    - _tell its presence to the_ `DataAttributePresenceConditionValidator`
  - `DataAttributePresenceConditionValidator.validate()`
  - `for each SDO of doType:`
    - _if it has no namespace or if its namespace_ `dependsOn` _current_ `namespace:`
      - _tell its presence to the_ `SubDataObjectPresenceConditionValidator`
  - `SubDataObjectPresenceConditionValidator.validate()`
  - `for each DA of doType:`
    - _find_ `typeValidator` _of_ `DA.name` _in_ `dataAttributeValidatorMap`
    - `typeValidator.validateAbstractDataAttribute(DA)`
    - _find_ `fcValidator` _of_ `DA.fc` _in_ `functionalConstraintValidatorMap`
    - `fcValidator.validateAbstractDataAttribute(DA)`
  - `for each SDO of doType:`
    - _find_ `cdcValidator` _of_ `SDO.name` _in_ `subDataObjectValidatorMap`
    - `cdcValidator.validateDOType(SDO.type)`


