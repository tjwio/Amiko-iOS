//
//  FeatherIcon.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

public extension UIFont {
    public class func featherFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "feather", size: size)
    }
}

public extension String {
    public static func featherIcon(name: FeatherIcon) -> String {
        return name.rawValue
    }
}

public enum FeatherIcon: String {
    case alertOctagon = "\u{e81b}"
    
    case alertCircle = "\u{e81c}"
    
    case activity = "\u{e81d}"
    
    case alertTriangle = "\u{e81e}"
    
    case alignCenter = "\u{e81f}"
    
    case airplay = "\u{e820}"
    
    case alignJustify = "\u{e821}"
    
    case alignLeft = "\u{e822}"
    
    case alignRight = "\u{e823}"
    
    case arrowDownLeft = "\u{e824}"
    
    case arrowDownRight = "\u{e825}"
    
    case anchor = "\u{e826}"
    
    case aperture = "\u{e827}"
    
    case arrowLeft = "\u{e828}"
    
    case arrowRight = "\u{e829}"
    
    case arrowDown = "\u{e82a}"
    
    case arrowUpLeft = "\u{e82b}"
    
    case arrowUpRight = "\u{e82c}"
    
    case arrowUp = "\u{e82d}"
    
    case award = "\u{e82e}"
    
    case barChart = "\u{e82f}"
    
    case atSign = "\u{e830}"
    
    case barChart2 = "\u{e831}"
    
    case batteryCharging = "\u{e832}"
    
    case bellOff = "\u{e833}"
    
    case battery = "\u{e834}"
    
    case bluetooth = "\u{e835}"
    
    case bell = "\u{e836}"
    
    case book = "\u{e837}"
    
    case briefcase = "\u{e838}"
    
    case cameraOff = "\u{e839}"
    
    case calendar = "\u{e83a}"
    
    case bookmark = "\u{e83b}"
    
    case box = "\u{e83c}"
    
    case camera = "\u{e83d}"
    
    case checkCircle = "\u{e83e}"
    
    case check = "\u{e83f}"
    
    case checkSquare = "\u{e840}"
    
    case cast = "\u{e841}"
    
    case chevronDown = "\u{e842}"
    
    case chevronLeft = "\u{e843}"
    
    case chevronRight = "\u{e844}"
    
    case chevronUp = "\u{e845}"
    
    case chevronsDown = "\u{e846}"
    
    case chevronsRight = "\u{e847}"
    
    case chevronsUp = "\u{e848}"
    
    case chevronsLeft = "\u{e849}"
    
    case circle = "\u{e84a}"
    
    case clipboard = "\u{e84b}"
    
    case chrome = "\u{e84c}"
    
    case clock = "\u{e84d}"
    
    case cloudLightning = "\u{e84e}"
    
    case cloudDrizzle = "\u{e84f}"
    
    case cloudRain = "\u{e850}"
    
    case cloudOff = "\u{e851}"
    
    case codepen = "\u{e852}"
    
    case cloudSnow = "\u{e853}"
    
    case compass = "\u{e854}"
    
    case copy = "\u{e855}"
    
    case cornerDownRight = "\u{e856}"
    
    case cornerDownLeft = "\u{e857}"
    
    case cornerLeftDown = "\u{e858}"
    
    case cornerLeftUp = "\u{e859}"
    
    case cornerUpLeft = "\u{e85a}"
    
    case cornerUpRight = "\u{e85b}"
    
    case cornerRightDown = "\u{e85c}"
    
    case cornerRightUp = "\u{e85d}"
    
    case cpu = "\u{e85e}"
    
    case creditCard = "\u{e85f}"
    
    case crosshair = "\u{e860}"
    
    case disc = "\u{e861}"
    
    case delete = "\u{e862}"
    
    case downloadCloud = "\u{e863}"
    
    case download = "\u{e864}"
    
    case droplet = "\u{e865}"
    
    case edit2 = "\u{e866}"
    
    case edit = "\u{e867}"
    
    case edit1 = "\u{e868}"
    
    case externalLink = "\u{e869}"
    
    case eye = "\u{e86a}"
    
    case feather = "\u{e86b}"
    
    case facebook = "\u{e86c}"
    
    case fileMinus = "\u{e86d}"
    
    case eyeOff = "\u{e86e}"
    
    case fastForward = "\u{e86f}"
    
    case fileText = "\u{e870}"
    
    case film = "\u{e871}"
    
    case file = "\u{e872}"
    
    case filePlus = "\u{e873}"
    
    case folder = "\u{e874}"
    
    case filter = "\u{e875}"
    
    case flag = "\u{e876}"
    
    case globe = "\u{e877}"
    
    case grid = "\u{e878}"
    
    case heart = "\u{e879}"
    
    case home = "\u{e87a}"
    
    case github = "\u{e87b}"
    
    case image = "\u{e87c}"
    
    case inbox = "\u{e87d}"
    
    case layers = "\u{e87e}"
    
    case info = "\u{e87f}"
    
    case instagram = "\u{e880}"
    
    case layout = "\u{e881}"
    
    case link2 = "\u{e882}"
    
    case lifeBuoy = "\u{e883}"
    
    case link = "\u{e884}"
    
    case logIn = "\u{e885}"
    
    case list = "\u{e886}"
    
    case lock = "\u{e887}"
    
    case logOut = "\u{e888}"
    
    case loader = "\u{e889}"
    
    case mail = "\u{e88a}"
    
    case maximize2 = "\u{e88b}"
    
    case map = "\u{e88c}"
    
    case mapPin = "\u{e88e}"
    
    case menu = "\u{e88f}"
    
    case messageCircle = "\u{e890}"
    
    case messageSquare = "\u{e891}"
    
    case minimize2 = "\u{e892}"
    
    case micOff = "\u{e893}"
    
    case minusCircle = "\u{e894}"
    
    case mic = "\u{e895}"
    
    case minusSquare = "\u{e896}"
    
    case minus = "\u{e897}"
    
    case moon = "\u{e898}"
    
    case monitor = "\u{e899}"
    
    case moreVertical = "\u{e89a}"
    
    case moreHorizontal = "\u{e89b}"
    
    case move = "\u{e89c}"
    
    case music = "\u{e89d}"
    
    case navigation2 = "\u{e89e}"
    
    case navigation = "\u{e89f}"
    
    case octagon = "\u{e8a0}"
    
    case package = "\u{e8a1}"
    
    case pauseCircle = "\u{e8a2}"
    
    case pause = "\u{e8a3}"
    
    case percent = "\u{e8a4}"
    
    case phoneCall = "\u{e8a5}"
    
    case phoneForwarded = "\u{e8a6}"
    
    case phoneMissed = "\u{e8a7}"
    
    case phoneOff = "\u{e8a8}"
    
    case phoneIncoming = "\u{e8a9}"
    
    case phone = "\u{e8aa}"
    
    case phoneOutgoing = "\u{e8ab}"
    
    case pieChart = "\u{e8ac}"
    
    case playCircle = "\u{e8ad}"
    
    case play = "\u{e8ae}"
    
    case plusSquare = "\u{e8af}"
    
    case plusCircle = "\u{e8b0}"
    
    case plus = "\u{e8b1}"
    
    case pocket = "\u{e8b2}"
    
    case printer = "\u{e8b3}"
    
    case power = "\u{e8b4}"
    
    case radio = "\u{e8b5}"
    
    case repeatIcon = "\u{e8b6}"
    
    case refreshCcw = "\u{e8b7}"
    
    case rewind = "\u{e8b8}"
    
    case rotateCcw = "\u{e8b9}"
    
    case refreshCw = "\u{e8ba}"
    
    case rotateCw = "\u{e8bb}"
    
    case save = "\u{e8bc}"
    
    case search = "\u{e8bd}"
    
    case server = "\u{e8be}"
    
    case scissors = "\u{e8bf}"
    
    case share2 = "\u{e8c0}"
    
    case share = "\u{e8c1}"
    
    case shield = "\u{e8c2}"
    
    case settings = "\u{e8c3}"
    
    case skipBack = "\u{e8c4}"
    
    case shuffle = "\u{e8c5}"
    
    case sidebar = "\u{e8c6}"
    
    case skipForward = "\u{e8c7}"
    
    case slack = "\u{e8c8}"
    
    case slash = "\u{e8c9}"
    
    case smartphone = "\u{e8ca}"
    
    case square = "\u{e8cb}"
    
    case speaker = "\u{e8cc}"
    
    case star = "\u{e8cd}"
    
    case stopCircle = "\u{e8ce}"
    
    case sun = "\u{e8cf}"
    
    case sunrise = "\u{e8d0}"
    
    case tablet = "\u{e8d1}"
    
    case tag = "\u{e8d2}"
    
    case sunset = "\u{e8d3}"
    
    case target = "\u{e8d4}"
    
    case thermometer = "\u{e8d5}"
    
    case thumbsUp = "\u{e8d6}"
    
    case thumbsDown = "\u{e8d7}"
    
    case toggleLeft = "\u{e8d8}"
    
    case toggleRight = "\u{e8d9}"
    
    case trash2 = "\u{e8da}"
    
    case trash = "\u{e8db}"
    
    case trendingUp = "\u{e8dc}"
    
    case trendingDown = "\u{e8dd}"
    
    case triangle = "\u{e8de}"
    
    case type = "\u{e8df}"
    
    case twitter = "\u{e8e0}"
    
    case upload = "\u{e8e1}"
    
    case umbrella = "\u{e8e2}"
    
    case uploadCloud = "\u{e8e3}"
    
    case unlock = "\u{e8e4}"
    
    case userCheck = "\u{e8e5}"
    
    case userMinus = "\u{e8e6}"
    
    case userPlus = "\u{e8e7}"
    
    case userX = "\u{e8e8}"
    
    case user = "\u{e8e9}"
    
    case users = "\u{e8ea}"
    
    case videoOff = "\u{e8eb}"
    
    case video = "\u{e8ec}"
    
    case voicemail = "\u{e8ed}"
    
    case volumeX = "\u{e8ee}"
    
    case volume2 = "\u{e8ef}"
    
    case volume1 = "\u{e8f0}"
    
    case volume = "\u{e8f1}"
    
    case watch = "\u{e8f2}"
    
    case wifi = "\u{e8f3}"
    
    case xSquare = "\u{e8f4}"
    
    case wind = "\u{e8f5}"
    
    case x = "\u{e8f6}"
    
    case xCircle = "\u{e8f7}"
    
    case zap = "\u{e8f8}"
    
    case zoomIn = "\u{e8f9}"
    
    case zoomOut = "\u{e8fa}"
    
    case command = "\u{e8fb}"
    
    case cloud = "\u{e8fc}"
    
    case hash = "\u{e8fd}"
    
    case headphones = "\u{e8fe}"
    
    case underline = "\u{e8ff}"
    
    case italic = "\u{e900}"
    
    case bold = "\u{e901}"
    
    case crop = "\u{e902}"
    
    case helpCircle = "\u{e903}"
    
    case paperclip = "\u{e904}"
    
    case shoppingCart = "\u{e905}"
    
    case tv = "\u{e906}"
    
    case wifiOff = "\u{e907}"
    
    case minimize = "\u{e88d}"
    
    case maximize = "\u{e908}"
    
    case gitlab = "\u{e909}"
    
    case sliders = "\u{e90a}"
    
    case starOn = "\u{e90b}"
    
    case heartOn = "\u{e90c}"
    
    case archive = "\u{e90d}"
    
    case arrowDownCircle = "\u{e90e}"
    
    case arrowUpCircle = "\u{e90f}"
    
    case arrowLeftCircle = "\u{e910}"
    
    case arrowRightCircle = "\u{e911}"
    
    case barChartLine1 = "\u{e912}"
    
    case barChartLine2 = "\u{e913}"
    
    case bookOpen = "\u{e914}"
    
    case code = "\u{e915}"
    
    case database = "\u{e916}"
    
    case dollarSign = "\u{e917}"
    
    case folderPlus = "\u{e918}"
    
    case gift = "\u{e919}"
    
    case folderMinus = "\u{e91a}"
    
    case gitCommit = "\u{e91b}"
    
    case gitBranch = "\u{e91c}"
    
    case gitPullRequest = "\u{e91d}"
    
    case gitMerge = "\u{e91e}"
    
    case linkedin = "\u{e91f}"
    
    case hardDrive = "\u{e920}"
    
    case moreVertical2 = "\u{e921}"
    
    case moreHorizontal2 = "\u{e922}"
    
    case rss = "\u{e923}"
    
    case send = "\u{e924}"
    
    case shieldOff = "\u{e925}"
    
    case shoppingBag = "\u{e926}"
    
    case terminal = "\u{e927}"
    
    case truck = "\u{e928}"
    
    case zapOff = "\u{e929}"
    
    case youtube = "\u{e92a}"
}
