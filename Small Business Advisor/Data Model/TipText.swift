//
//  TipText.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import UIKit

protocol StringFactory {
    static var max: Int { get }
    
    static func produce(for index: Int) -> NSAttributedString
}

func BodyTextFormatting() -> [NSAttributedStringKey : NSObject] {
    
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    
    let formatting = [
        NSAttributedStringKey.font :            UIFont.boldSystemFont(ofSize: 18),
        NSAttributedStringKey.foregroundColor:  UIColor(red: 0.55, green: 0.78, blue: 0.25, alpha: 1.0)
    ]
    
    return formatting
}

struct TextFactory: StringFactory {
    
    static var max = 105   // <-- Eventually these will have to calculate dynamic totals...after coredata, before icloud
    
    static func produce(for index: Int) -> NSAttributedString {
        return NSAttributedString(string: unattributedString(for: index), attributes: BodyTextFormatting())
    }
    
    fileprivate static func unattributedString(for index: Int) -> String {
        switch index {
        case ..<2:  return "Only when the commercial potential of an idea is identified, does it become an actual business opportunity; when you can turn a profit by selling a product / service."
        case 2:     return "There are several grant, loan and bond opportunities available through the Small Business Administration."
        case 3:     return "Small US companies have growth potential abroad, in industries where there is demand for high quality American products."
        case 4:     return "A business should identify value for its customers, and it should also determine the value its customers represent."
        case 5:     return "For every group of potential customers you identify, you should find out as much as you can about what they think of your product / services."
        case 6:     return "Incorporate the notion of customer value and recognize that this notion can change over time."
        case 7:     return "The complexity and difficulty of building a comprehensive business plan can be significantly reduced by using one of the available business-planning software packages. Check out these sites: liveplan.com, lawdepot.com, businessplanpro.com, etc..."
        case 8:     return "A critical ability of any business is it’s ability to accurately forecast."
        case 9:     return "Vision Statement - The long term purpose and big picture, idealized expectation for the business; the direction it’s going."
        case 10:    return "Mission Statement - An explanation of the business’s purpose, narrowed down to it’s core essence."
        case 11:    return "Strategy - How a company intends to provide it’s customers with value, within operational parameters and constraints."
        case 12:    return "Growth, Product Differentiation, Price Focus & Acquisitions are common Strategic approaches."
        case 13:    return "There are a variety of techniques, including brainstorming and mind mapping, that can add structure and facilitate creativity in groups."
        case 14:    return "A Pricing Strategy requires clearly enumerated Pricing Objectives."
        case 15:    return "Pricing Strategies commonly considered by small businesses include Discount Pricing, Cost Based Pricing, Prestige Pricing, Even Odd Pricing and Geographic Pricing."
        case 16:    return "How a company prices their offerings has a big impact on consumer expectations."
        case 17:    return "Executive Summary - A single page (at most, two pages) synopsis of your Marketing Plan."
        case 18:    return "Market Segments can be divided down to an even more granular level, to produce isolated niches or unmet needs."
        case 19:    return "A Cash Flow Strategy comes before, and should be consulted during the development of a Marketing Strategy."
        case 20:    return "Metrics allow for performance tracking, and are an essential tool when managing a Supply Chain."
        case 21:    return "Don’t end up like the 60% of small businesses that fail within 2 years of experiencing a major disaster, have a Disaster Recovery Plan that incorporates appropriate insurance packages."
        case 22:    return "In order for a Disaster Recovery Plan to be successful, it must cover communications, investment protection and mechanisms to continue operations."
        case 23:    return "Liquidation, Family Succession, Selling, Bankruptcy or taking the company Public are some common exit strategies that a business owner can consider."
        case 24:    return "The simpler the organizational structure, the more positive the impact on cash flow."
        case 25:    return "When transitioning from a sole proprietorship to a company with multiple employees, having an organizational structure already in place will increase productivity, prevent time wasting behaviors from getting established and ease task adoption."
        case 26:    return "Without a clear purpose statement, meeting attendees will resent the interruption of their schedules and question the direction."
        case 27:    return "An Agenda should include the purpose, attendees / roles and topics of a meeting. It may also include a discussion of resources, key issues and various constraints."
        case 28:    return "An Activity Log can greatly assist time management, and allows retroactive time audits to easily be implemented."
        case 29:    return "Marketing Research, Planning and Campaigns are universally adopted by successful businesses because they work well."
        case 30:    return "Customer Value is equal to Perceived Benefits less Perceived Costs, and can categorized as Functional, Social, Epistemic, Emotional and Conditional."
        case 31:    return "The Customer Value Proposition should be a key consideration in the Marketing Plan."
        case 32:    return "To prevent cash flow issues, the Marketing Plan should balance the needs to minimize costs and maximize quality."
        case 33:    return "Cloud, Software-As-A-Solution (SaaS) and other technologies can be helpful at every and any stage, from development to execution."
        case 34:    return "Every Marketing Plan should include an Executive Summary, Vision / Mission statements, Situation Analysis, Marketing Objectives / Strategy and Financials. It should explain how to implement, evaluate and control the process."
        case 35:    return "Although a marketing plan should cover one year in detail, this does not mean that a business should ignore the longer term."
        case 36:    return "There are many reasons why small businesses should have a marketing plan, not the least of which is that a marketing plan can help the business minimize risk, mistakes and failures."
        case 37:    return "Social Media lends itself well to Marketing Campaigns with little to no budget."
        case 38:    return "Small business owners should be familiar and comfortable with the terms promotion, marketing communications and integrated marketing communications (IIMC)."
        case 39:    return "Concerning emails, you’ll find many versions of “The Four C’s.” We prefer Clear, Correct, Concise and Complete."
        case 40:    return "A Marketing Communications Mix will include a combination of advertising, sales promotion, events, publicity, direct marketing, interactive marketing and personal selling."
        case 41:    return "Marketing is the only activity that generates leads and traffic for most small businesses, critical for revenue."
        case 42:    return "The key element in the marketing mix is the product. Without the product, any discussion of price, promotion or positioning is pointless."
        case 43:    return "The product or service packaging communicates both emotional and functional benefits to the buyer, serving as an important means of product differentiation."
        case 44:    return "Position your solution for maximum adoption."
        case 45:    return "Differentiation and positioning considerations are relevant to each element of the marketing mix as well as the physical and online marketplaces."
        case 46:    return "Operations encompasses the Sales Team and ensures that targets and objectives are being met through performance tracking."
        case 47:    return "In small digital startups, especially at the early development stages, Operations facilitates the rest of the team's efforts."
        case 48:    return "Customer Success is being recognized more and more as a key part of a company's relationship with their clients."
        case 49:    return "The job of operations management is to oversee the process of transforming resources into goods and services."
        case 50:    return "The Supply Chain includes Procurement, Operations, Distribution and Integration."
        case 51:    return "Information Technology has opened the door to multiple ways to improve office productivity, not the least of which is the virtual employee."
        case 52:    return "While remote workers can reduce expenses and grant you access to labor markets outside the local area, not every personality type is able to maintain their productivity working out of the office."
        case 53:    return "Software exists that can assist with improving one’s own personal time management."
        case 54:    return "The use of cloud computing can significantly reduce costs and improve the financial position of a firm. It also facilitates centralized automation."
        case 55:    return "Cost savings brought about by supply chain management systems can produce amplified improvements in cash flow."
        case 56:    return "Good accounting systems can help a firm provide value to its customers through better billing and increased efficiency."
        case 57:    return "Small businesses today can acquire very powerful computer accounting software packages. These packages are affordable and relatively easy to use."
        case 58:    return "CRM software was formerly so complex and expensive that it was suitable for large corporations only. Now it can be used by the smallest of businesses to improve customer value."
        case 59:    return "zoho.com has powerful CRM tools and is free to groups of 10 or less"
        case 60:    return "fiverr.com is a great resource for many outsourcing needs."
        case 61:    return "The initial time and effort investment to configure automation has a huge return, when implemented properly."
        case 62:    return "The success of a business depends on its ability to identify the unmet needs of consumers and to develop products that meet those needs at a reasonable cost."
        case 63:    return "Businesses must become proactive in attempting to identify the value proposition of their customers. They must know how to listen to the VOC (voice of the customer)."
        case 64:    return "Focusing on customer value improves customer loyalty, which improves cash flow."
        case 65:    return "Dimensions of Service Quality: Tangibles, Reliability, Responsiveness, Assurance and Empathy."
        case 66:    return "Small businesses can be proactive in preserving cash flow through a variety of simple actions. Some of these include expense tracking, projecting future sales and automation."
        case 67:    return "Operational Efficiency is just as important in Service Industries as it is in Manufacturing."
        case 68:    return "7 Sources of Service Waste: delay, duplication, unnecessary motion, unclear communication, incorrect inventory, errors and opportunity lost."
        case 69:    return "7 Sources of Manufacturing Wastes: transportation, inventory, motion, waiting, over processing, over production and defects."
        case 70:    return "Quality management and lean programs can generate efficiencies that produce significant cost savings."
        case 71:    return "Accounting is one of the oldest activities of human civilization and dates back over five thousand years."
        case 72:    return "The proper management of a firm’s cash flow requires a commitment to planning for expenses proactively, and the management that entails."
        case 73:    return "A cash-based accounting system is for small firms with sales totaling less than $1 million. For larger companies, Accrual accounting systems measure profits instead of cash."
        case 74:    return "Breakeven analysis is a technique used to determine the level of sales needed to 'break even' or to operate at a sales level at which you have neither profit nor loss."
        case 75:    return "Fixed costs are costs that don’t change as the amount of goods sold fluctuates."
        case 76:    return "Variable costs are costs that changes, in total, as the quantity of goods sold fluctuates. However, they stay constant on a per-unit basis."
        case 77:    return "Financial leverage — the ratio of debt to equity — can improve the economic performance of a business as measured by ROI."
        case 78:    return "Balance Sheet - What a business owns (assets) and what claims are on the business (liabilities)."
        case 79:    return "Income Statement - A list of the business’s profits, usually accompanied by expenses and calculated into a net margin."
        case 80:    return "Cash flow is the lifeblood of a business’s operation. Cash flow projections are vital for any business."
        case 81:    return "Revenue is vanity. Margin is sanity. Cash is King!"
        case 82:    return "Financial ratios enable external constituencies to evaluate the performance of a firm with respect to other firms in a particular industry."
        case 83:    return "Financial ratios can be grouped into five categories: Liquidity Ratios, Financial Leverage Ratios, Asset Management or Efficiency Ratios, Profitability Ratios and Market Value Ratios."
        case 84:    return "Ratio Analysis can help management teams to identify areas of concern."
        case 85:    return "Business owners should be aware of their own and their business’s creditworthiness."
        case 86:    return "The costs of quality improvements are always less than the costs of poor quality; hence quality is free."
        case 87:    return "The selection process for an accounting service should be carefully considered. The evaluation process should consider the following: expertise in a particular type of business or industry, rapport, availability of additional consulting services and the ability to support computerized accounting systems."
        case 88:    return "Accounting systems may be divided into two major types: cash basis and accrual basis."
        case 89:    return "Succession planning is critical to the success of passing a family business to family members."
        case 90:    return "Hiring Process - Identifying Job Requirements, Choosing Sources of Candidates, Reviewing Applications and CV’s, Interviewing Candidates, Conducting Employment Tests (if desired), Checking References, Conducting Follow-Up Interviews (if needed), Selecting a Candidate and Making an Offer."
        case 91:    return "Good leaders are dynamic, adapting their style to a given situation. These styles often include Autocratic, Democratic and Laissez-Faire. Bad leaders are incapable of adapting, with only a single style to rely on."
        case 92:    return "The cost of unethical behavior can be staggering."
        case 93:    return "Companies that “out behave” the competition ethically tend to outperform them financially."
        case 94:    return "Establishing an Ethics Policy is critical for creating an ethical work environment."
        case 95:    return "Ethical behavior in business improves the workplace climate and will ultimately improve the bottom line."
        case 96:    return "Small businesses are the new target for cybercrime. As a result, small businesses must pay attention to their website security because it will protect the business and influence customer trust."
        case 97:    return "Protecting your clients’ information is more important than protecting your own intellectual property. If either are exposed, it may be impossible for your business to recover."
        case 98:    return "Keeping your software up to date not only improves functionality, but also removes security holes that have been identified by developers."
        case 99:    return "Some industries require additional and / or unique security protocols and procedures to protect their interests and comply with legal regulations."
        case 100:   return "Every small business must select a legal form of ownership. It is one of the first decisions that a small business owner must make."
        case 101:   return "The most common forms of legal structure are the sole proprietorship, the partnership, and the corporation. An LLC is a relatively new business structure."
        case 102:   return "Avoid stress and high fees by using sites like clerky.com, and ensure your legal paperwork is done correctly."
        case 103:   return "Small businesses that are incorporated outperform unincorporated small businesses in terms of profitability, employment growth, sales growth and other measures."
        case 104:   return "A Corporation is an artificial person with most of the legal rights of a real human being."
        default:    return "A Patent grants you “the right to exclude others from making, using, offering for sale, or selling” the invention in the United States for twenty years."
        }
    }
}
