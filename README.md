# Peach Shop — Linode + Terraform

This project creates one Linode Ubuntu server, installs Nginx, and publishes the static site in `site/`:

- `index.html` — peach-shop landing page
- `login.html` — bilingual peach-themed Supabase login page
- `reset-password.html` — Supabase password reset page

## Before you start

1. Install Terraform (1.5+) and have a Linode account with billing enabled.
2. Create a Linode API token with permissions to create/manage Linodes. Set it in your terminal, not in source code:

   ```bash
   export LINODE_TOKEN="your-linode-api-token" ----> 8bbbb473a6674235caa6df10e040c10f846ca8ef7a8e3f121223bfcc156ff9c9
   ```

3. Make an SSH key if you don't have one already:

   ```bash
   ssh-keygen -t ed25519 -C "peach-shop-linode"
   cat ~/.ssh/id_ed25519.pub
   ```

4. Copy `terraform.tfvars.example` to `terraform.tfvars` and replace `ssh_public_key` with the full output from `cat ~/.ssh/id_ed25519.pub`.

## Deploy

Run these commands from this directory:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and paste your real public SSH key.
terraform init
terraform validate
terraform plan
terraform apply
```

Review the plan and type `yes` to create the Linode. Terraform prints `website_url` and `login_url` when done. Give cloud-init about 2–5 minutes to install Nginx before opening the URL.

## Supabase setup

The login page uses the Supabase project URL and publishable key already configured in `site/login.html`. In Supabase → Authentication → URL Configuration:

- Set the Site URL to your final HTTPS domain once DNS and TLS are configured.
- Add your exact login and password-reset redirect URLs to the allowed Redirect URLs.
- The login page sends successful sessions to `index.html` and password recovery to `reset-password.html`.

The first deployment is HTTP on the server IP. For production, point a domain's DNS A record at the Linode IP and configure HTTPS (for example, Certbot + Let's Encrypt) before using real users. Supabase redirect URLs must match the actual scheme, host, and path.

## Update site files

Edit files in `site/`, then run `terraform apply` to rebuild the archive and update the instance's metadata. Note: cloud-init normally runs only on first boot, so changing files after the instance is created will not automatically publish them. For updates to an existing server, copy files over SSH/SCP or recreate the instance. For a simple manual update after deployment, from this directory you can run:

```bash
scp site/* root@YOUR_LINODE_IP:/var/www/html/
```

(Use the private SSH key matching the public key you provisioned.)

## Destroy

When you no longer need the server, run:

```bash
terraform destroy
```

Review the plan and type `yes`. This deletes the Linode and its attached data. Linode usage may incur charges while it exists.

## Security notes

- Keep `LINODE_TOKEN`, your private SSH key, and `terraform.tfstate` private.
- Never put a Supabase `service_role` or secret key in browser HTML. The page should contain only the publishable key.
- A redirect to `index.html` does not by itself protect private content. Add a Supabase session check to the main page and secure private data with Supabase Row Level Security policies if the page is intended to be login-only.
