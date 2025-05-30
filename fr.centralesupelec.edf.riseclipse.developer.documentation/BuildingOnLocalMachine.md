----
Copyright (c) 2023-24 CentraleSupélec & EDF.

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

**Web site:**
 * https://riseclipse.github.io/
----

## Scenario

This scenario corresponds to the introduction of new versions of the tools used by RiseClipse. It shows how to build the SCL validator on a machine to test it before building and deploying this update on GitHub.



## Needed Tools

- JDK 17 or higher ([here for example](https://adoptium.net/))

- [**Maven**](https://maven.apache.org)

- [**Eclipse IDE for Java Developers**](https://eclipseide.org)

- Install from the corresponding Eclipse update site:
    - **Eclipse Plug-in Development Environment**
    - **EMF - Eclipse Modeling Framework SDK**
    - **OCL Examples and Editors SDK**

- Install the **CBI Target Platform Definition DSL** generator using the `https://download.eclipse.org/cbi/updates/tpd/nightly/latest` update site
- Install the **CBI Aggregator Editor** using the `https://download.eclipse.org/cbi/updates/p2-aggregator/tools/nightly` update site


## Process

- Clone projects `riseclipse-developer`, `riseclipse-main`, `riseclipse-validator-ocl`, `riseclipse-metamodel-scl2003`, `riseclipse-metamodel-nsd2016`, import in the Eclipse workspace

- Create a branch `develop` for project `riseclipse-developer`

- Edit `riseclipse-developer/fr.centralesupelec.edf.riseclipse.developer.eclipse/fr.centralesupelec.edf.riseclipse.developer.eclipse.tpd` so that it points to the latest Eclipse release and the corresponding Orbit site
- Generate the corresponding target file

- Edit `riseclipse-developer/fr.centralesupelec.edf.riseclipse.developer.p2_to_m2/src/main/resources/riseclipse.aggr`, update the mapped repositories, update the versions


- Edit `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml`:
    - Update `project.repositories.repository` with the URL of the new Eclipse version
    - Update `project.properties.*`:
        - Update `.riseclipse-target-platform-version` with `project.version` with `-SNAPSHOT`
        - Update `.maven-*` with latest versions using [https://maven.apache.org/plugins/index.html](https://maven.apache.org/plugins/index.html)
        - Update `.tycho-version` with latest one (see on [https://projects.eclipse.org/projects/technology.tycho](https://projects.eclipse.org/projects/technology.tycho)
        - Use the generated target file to update plugin versions
        
- Edit `riseclipse-developer/fr.centralesupelec.edf.riseclipse.developer.p2_to_m2/pom.xml`
    - Update `project.version` and `project.parent.version` to be the same as `project.version` from `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` (with `-SNAPSHOT`)

- Commit to `develop` (but don't push to GitHub, building on GitHub will fail in this state)

- Use a `~/.m2/toolchains.xml` file to specify which jdk to use for the build (see [https://maven.apache.org/guides/mini/guide-using-toolchains.html](https://maven.apache.org/guides/mini/guide-using-toolchains.html), version should be `17` and vendor `temur`)

- In a Terminal, go to `riseclipse-developper` and run `mvn clean install`
- Go to `riseclipse-developper/fr.centralesupelec.edf.riseclipse.developer.p2_to_m2` and run `mvn clean install`


- Go to `riseclipse-main`:
    - Create a `develop` branch
    - Edit `pom.xml` and set the `project.parent.version` to the same as `riseclipse-developper/pom.xml:project.version` (with `-SNAPSHOT`)
    - Edit `fr.centralesupelec.edf.riseclipse.main/META-INF/MANIFEST.MF` and set `Bundle-Version` to the same as `pom.xml:project.version`, replacing `-SNAPSHOT` with `.qualifier`
    - Commit to `develop`
    - Run `mvn clean install`

- Do the same for `riseclipse-validator-ocl`, `riseclipse-metamodel-scl2003`, `riseclipse-metamodel-nsd2016` (warning: there can be several `META-INF/MANIFEST.MF` to change)

- Go to `riseclipse-validator-scl2003`:
    - Create a `develop` branch
    - Edit `pom.xml`:
        - Set the `project.parent.version` to the same as `riseclipse-developper/pom.xml:project.version` (with `-SNAPSHOT`)
        - Update the versions of **RiseClipse needed plugins** to the current ones (with `-SNAPSHOT`)
    - Edit `fr.centralesupelec.edf.riseclipse.iec61850.scl.validator*/META-INF/MANIFEST.MF`
        - Set `Bundle-Version` to the same as `pom.xml:project.version`, replacing `-SNAPSHOT` with `.qualifier`
        - Change `Require-Bundle` versions of RiseClipse bundles to current ones
    - Commit to `develop`
    - Run `mvn clean package`
    
    
