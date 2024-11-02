import hudson.security.*

// Set up the security realm and create a new admin account
def jenkins = Jenkins.instance
def realm = new HudsonPrivateSecurityRealm(false)
jenkins.setSecurityRealm(realm)

// Create an admin user account with username and password
def adminUsername = 'admin'
def adminPassword = 'admin_password'  // Change this to a secure password
realm.createAccount(adminUsername, adminPassword)

// Check if the matrix-auth plugin is available to set up authorization strategy
if (jenkins.pluginManager.getPlugin("matrix-auth") != null) {
    def strategy = new GlobalMatrixAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, adminUsername)
    jenkins.setAuthorizationStrategy(strategy)
} else {
    println("Matrix Authorization Strategy plugin not installed, skipping authorization configuration.")
}

// Save the Jenkins instance
jenkins.save()

