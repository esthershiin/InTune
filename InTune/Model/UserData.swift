//
//  UserData.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

/* Notes for development: Will probably need an abstraction for a user (class or struct?). The class will need a username, name, date joined, top match, average match score, and maybe a data structure that holds all the matches. */

import Foundation
import SpotifyiOS.h

var isLoggedIn: Bool = true

var configuration: SPTConfiguration = [[SPTConfiguration, alloc] initWithClientID:@"your_client_id" redirectURL:[NSURL urlWithString:@"your_redirect_uri"]];


