/**
 * 
 */
package Interfaces;

/** 
 * <!-- begin-UML-doc -->
 * <!-- end-UML-doc -->
 * @author vincent
 * @generated "UML to Java (com.ibm.xtools.transform.uml2.java5.internal.UML2JavaTransform)"
 */
public interface IFichier {
	/** 
	* <!-- begin-UML-doc -->
	* <!-- end-UML-doc -->
	* @param path
	* @return
	* @generated "UML to Java (com.ibm.xtools.transform.uml2.java5.internal.UML2JavaTransform)"
	*/
	public ILivre loadLivre(String path);

	/** 
	* <!-- begin-UML-doc -->
	* <!-- end-UML-doc -->
	* @param path
	* @generated "UML to Java (com.ibm.xtools.transform.uml2.java5.internal.UML2JavaTransform)"
	*/
	public void saveLivre(String path);
}