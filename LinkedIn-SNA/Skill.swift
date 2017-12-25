//
//	Skill.swift
//
//	Create by Egzon Arifi on 23/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class Skill {

	var endorsmentCount : String!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		endorsmentCount = dictionary["endorsmentCount"] as? String
		name = dictionary["name"] as? String
	}

}
