----
Copyright (c) 2025 CentraleSupélec & EDF.

All rights reserved. This program and the accompanying materials
are made available under the terms of the Eclipse Public License v2.0
which accompanies this distribution, and is available at
https://www.eclipse.org/legal/epl-v20.html

This file is part of the RiseClipse tool
 
**Contributors:**
 * Computer Science Department, CentraleSupélec
 * EDF R&D

**Contacts:**
 * dominique.marcadet@centralesupelec.fr
 * aurelie.dehouck-neveu@edf.fr
 * jerome.cantenot@edf.fr

**Web site:**
 * https://riseclipse.github.io/
----


# RiseClipse metamodels

Some choices have been done about metamodels used by RiseClipse, this document tries to list them.

## Creation of metamodels

A RiseClipse metamodel is an Ecore model. Two different ways have been used:
* For CIM metamodels:
  * the UML version is exported from Enterprise Architect to XMI,
  * a java tool converts this XMI to Eclipse UML,
  * a QVTo is used from Eclipse UML to Ecore.
* For SCL and NSD metamodels:
  * EMF is able to create an Ecore from an XSD.

In both cases, resulting Ecore models are manually modified for various reasons which are listed below (mainly for IEC61850 models, CIM models are not used anymore).

## Adaptation of metamodels

These modifications concerned the SCL and NSD metamodels.

#### Ecore
* The package name is simplified if needed.
* A root class is added in the inheritance hierarchy (SclObject, NsdObject).
* The T prefix used by the XSD for complex type names is removed.
* The associations are navigable in both directions by adding an EReference to the class which missed it and using the EOpposite property:
  * the new EReference uses the prefix Parent for its name,
  * its Transient property is set to true.
* For EReference properties:
  * Lower Bound is set to 0 (OCL will be used if the XSD sets the minimum cardinality to 1),
  * Ordered is set to false unless the order of sub-objects is meaningful,
  * Unsettable is set to true.
* New associations are added to make explicit some implicit links.

#### Genmodel

* All
  * Versions are adjusted to current versions used by RiseClipse.
  * Copyright Text is added before generation of Java files.
* Template & Merge
  * Cleanup and Code Formatting set to true (the RiseClipse Java Formatter is expected to be loaded by Eclipse)

#### plugin.xml
* The extension fr.centralesupelec.edf.riseclipse.main.meta_models is added

#### Other
* The edit project is generated
* An utilities project is created for the model loader

