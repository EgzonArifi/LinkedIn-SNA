//
//	User.swift
//
//	Create by Egzon Arifi on 23/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class User {

	var company : String!
	var companyFounded : String!
	var companyHeadquarters : String!
	var companyIndustry : String!
	var companyLinkedin : String!
	var companySize : String!
	var companyWebsite : String!
	var email : String!
	var firstName : String!
	var job : String!
	var lastName : String!
	var location : String!
	var profileUrl : String!
	var skills : [Skill]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		company = dictionary["company"] as? String
		companyFounded = dictionary["companyFounded"] as? String
		companyHeadquarters = dictionary["companyHeadquarters"] as? String
		companyIndustry = dictionary["companyIndustry"] as? String
		companyLinkedin = dictionary["companyLinkedin"] as? String
		companySize = dictionary["companySize"] as? String
		companyWebsite = dictionary["companyWebsite"] as? String
		email = dictionary["email"] as? String
		firstName = dictionary["firstName"] as? String
		job = dictionary["job"] as? String
		lastName = dictionary["lastName"] as? String
		location = dictionary["location"] as? String
		profileUrl = dictionary["profileUrl"] as? String
		skills = [Skill]()
		if let skillsArray = dictionary["skills"] as? [NSDictionary]{
			for dic in skillsArray{
				let value = Skill(fromDictionary: dic)
				skills.append(value)
			}
		}
	}

}
