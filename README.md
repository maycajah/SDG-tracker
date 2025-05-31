# SDG Impact Tracker

A decentralized smart contract on the Stacks blockchain for tracking, funding, and verifying Sustainable Development Goals (SDG) projects. This contract enables transparent impact measurement and community-driven funding for sustainability initiatives.

## Overview

The SDG Impact Tracker smart contract provides a decentralized platform where:
- Organizations and individuals can create SDG-aligned projects
- Community members can contribute funding to meaningful initiatives
- Authorized verifiers can validate project impact and outcomes
- Project creators can provide regular updates with evidence of progress

## Features

### 🎯 Project Management
- Create projects aligned with any of the 17 UN SDGs
- Set funding targets and track contributions
- Provide detailed descriptions and impact goals

### 💰 Decentralized Funding
- Community-driven contribution system
- Transparent tracking of individual and total contributions
- Automatic funding updates for projects

### ✅ Impact Verification
- Authorized verifier system for quality assurance
- Impact scoring (0-100 scale) for verified projects
- Evidence-based verification process

### 📊 Progress Tracking
- Regular project updates from creators
- Impact evidence documentation
- Timestamped progress reports

## Contract Functions

### Public Functions

#### `create-project`
```clarity
(create-project title description sdg-goal funding-target)
```
Creates a new SDG project with specified parameters.

**Parameters:**
- `title`: Project title (max 100 characters)
- `description`: Project description (max 500 characters)
- `sdg-goal`: SDG number (1-17)
- `funding-target`: Target funding amount

#### `contribute-to-project`
```clarity
(contribute-to-project project-id amount)
```
Contributes funding to an existing project.

**Parameters:**
- `project-id`: Unique project identifier
- `amount`: Contribution amount

#### `add-project-update`
```clarity
(add-project-update project-id update-id description impact-evidence)
```
Adds progress update to a project (creator only).

**Parameters:**
- `project-id`: Project identifier
- `update-id`: Unique update identifier
- `description`: Update description (max 300 characters)
- `impact-evidence`: Evidence of impact (max 200 characters)

#### `verify-project`
```clarity
(verify-project project-id impact-score)
```
Verifies a project and assigns impact score (authorized verifiers only).

**Parameters:**
- `project-id`: Project identifier
- `impact-score`: Impact score (0-100)

#### `authorize-verifier`
```clarity
(authorize-verifier verifier)
```
Authorizes a new verifier (contract owner only).

#### `revoke-verifier`
```clarity
(revoke-verifier verifier)
```
Revokes verifier authorization (contract owner only).

### Read-Only Functions

#### `get-project`
```clarity
(get-project project-id)
```
Returns complete project information.

#### `get-project-update`
```clarity
(get-project-update project-id update-id)
```
Returns specific project update details.

#### `get-user-contribution`
```clarity
(get-user-contribution user project-id)
```
Returns user's contribution amount to a specific project.

#### `is-authorized-verifier`
```clarity
(is-authorized-verifier verifier)
```
Checks if a principal is an authorized verifier.

#### `get-total-projects`
```clarity
(get-total-projects)
```
Returns the total number of projects created.

## SDG Goals Reference

The contract supports all 17 UN Sustainable Development Goals:

1. No Poverty
2. Zero Hunger
3. Good Health and Well-being
4. Quality Education
5. Gender Equality
6. Clean Water and Sanitation
7. Affordable and Clean Energy
8. Decent Work and Economic Growth
9. Industry, Innovation and Infrastructure
10. Reduced Inequality
11. Sustainable Cities and Communities
12. Responsible Consumption and Production
13. Climate Action
14. Life Below Water
15. Life on Land
16. Peace and Justice Strong Institutions
17. Partnerships to Achieve the Goal

## Error Codes

- `u100`: Owner-only function called by non-owner
- `u101`: Project not found
- `u102`: Invalid impact score or parameter
- `u103`: Project already exists
- `u104`: Unauthorized verifier

## Usage Examples

### Creating a Project
```clarity
(contract-call? .sdg-impact-tracker create-project
  "Solar Panel Installation in Rural Areas"
  "Installing solar panels to provide clean energy access to 100 rural households"
  u7  ;; SDG 7: Affordable and Clean Energy
  u50000)  ;; Funding target
```

### Contributing to a Project
```clarity
(contract-call? .sdg-impact-tracker contribute-to-project u1 u1000)
```

### Adding a Project Update
```clarity
(contract-call? .sdg-impact-tracker add-project-update
  u1
  u1
  "Completed installation of 25 solar panels"
  "Photo documentation and energy output measurements available")
```

## Deployment Instructions

1. Deploy the contract to Stacks testnet or mainnet
2. The deployer automatically becomes the first authorized verifier
3. Authorize additional verifiers as needed using `authorize-verifier`
4. Projects can be created immediately after deployment

## Security Features

- **Access Control**: Function-level permissions for sensitive operations
- **Input Validation**: Comprehensive parameter checking
- **Error Handling**: Graceful failure with descriptive error codes
- **Immutable Records**: All contributions and updates are permanently recorded

## Contributing

To contribute to this project:

1. Fork the repository
2. Create a feature branch
3. Test thoroughly on Stacks testnet
4. Submit a pull request with detailed description

## License

This project is open source and available under the MIT License.

## Support

For questions, issues, or feature requests, please open an issue in the repository or contact the development team.

---

**Built for a sustainable future on the Stacks blockchain** 🌱
