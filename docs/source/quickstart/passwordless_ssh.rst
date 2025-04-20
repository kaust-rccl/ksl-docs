.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Ibex passwordless login quickstart
    :keywords: ibex, login, passwordless

.. _quickstart_ibex_login_passwordless:

==========================
Password-less SSH
==========================
To configure password-less SSH, generate an SSH key pair and enable it for authentication.

1. Generate an SSH Key Pair
===========================
**On Linux/macOS:**

Open a terminal and run:

.. code-block:: bash

    ssh-keygen -t rsa -b 4096 -C "your_email@kaust.edu.sa"

Keys are saved in ``~/.ssh/id_rsa`` (private) and ``~/.ssh/id_rsa.pub`` (public).

**On Windows:**

For Windows 10 or later, open PowerShell/Command Prompt and run:

.. code-block:: bash

    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

Keys are saved in ``C:\Users\<yourname>\.ssh\`` by default.  
Alternatively, use **PuTTYgen** if you prefer PuTTY.

.. note::
    When prompted, enter a strong passphrase to encrypt your private key.

2. Copy Your Public Key to the Remote System
============================================
**Method 1: Using `ssh-copy-id`**  
If available (Linux/macOS/Windows Git Bash):

.. code-block:: bash

    ssh-copy-id username@ilogin.ibex.kaust.edu.sa

**Method 2: Manual Copy**  
If `ssh-copy-id` is unavailable:

1. Copy the contents of your public key:
   - Linux/macOS: ``~/.ssh/id_rsa.pub``  
   - Windows: ``C:\Users\<yourname>\.ssh\id_rsa.pub``

2. Log in to Ibex with your password:

.. code-block:: bash

    ssh -X username@ilogin.ibex.kaust.edu.sa

3. Paste the key into ``~/.ssh/authorized_keys`` on Ibex.  
   If the ``.ssh`` directory doesn’t exist:

.. code-block:: bash

    mkdir -p ~/.ssh
    nano ~/.ssh/authorized_keys

4. Set secure permissions:

.. code-block:: bash

    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys

3. Test the SSH Connection
==========================
Verify password-less login:

.. code-block:: bash

    ssh -X username@ilogin.ibex.kaust.edu.sa

You should only be prompted for your **key passphrase** (if set), not your Ibex password.

.. note::
    If prompted for a password:
    - Specify the key path explicitly (if non-default):
    
    .. code-block:: bash

        ssh -X -i /path/to/id_rsa username@ilogin.ibex.kaust.edu.sa