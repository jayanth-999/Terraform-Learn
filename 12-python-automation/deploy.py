import subprocess
import sys
import os

def run_terraform(command, env):
    """Runs a terraform command with the given environment variable."""
    print(f"🚀 Running: terraform {command} for env={env}...")
    
    # Use a list of arguments to avoid shell quoting issues on Windows
    cmd = ["terraform", command]
    
    if command == "apply":
        cmd.extend(["-var", f"environment={env}", "-auto-approve"])

    try:
        # shell=False is safer and avoids quoting hell
        subprocess.run(cmd, shell=False, check=True, cwd=os.path.dirname(__file__))
        print("✅ Success!")
    except subprocess.CalledProcessError:
        print("❌ Error occurred!")
        sys.exit(1)

def main():
    print("🤖 Welcome to the Infrastructure Vending Machine")
    print("-----------------------------------------------")
    
    # 1. Ask the user for the target environment
    env = input("Which environment do you want to deploy? (dev/prod): ").strip().lower()
    
    if env not in ["dev", "prod"]:
        print("⚠️  Invalid environment. Please choose 'dev' or 'prod'.")
        return

    # 2. Run Terraform Init
    run_terraform("init", env)

    # 3. Run Terraform Apply
    run_terraform("apply", env)

    print(f"\n🎉 Deployment to {env} complete! Check the folder for config-{env}.json")

if __name__ == "__main__":
    main()
