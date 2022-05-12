### UKRDC GPG encryption

UKRDC provide a
[public gpg key](https://github.com/renalreg/ukrr_public_keys/blob/main/UKRDC/UKRDC_Public.asc)
that we use to encrypt data we send to them. The key is included in the code base here.

Note that the UKRDC processing uses the "Patient View (Renal)" public key at time of writing but
might switch to the proper UKRDC one at some point.

There are two ENV vars to change when changing public key:

Using the PV key:

```
UKRDC_PUBLIC_KEY_NAME=patientview
UKRDC_GPG_RECIPIENT=Patient View (Renal)
```

Using the UKRDC key:

```
UKRDC_PUBLIC_KEY_NAME=ukrdc
UKRDC_GPG_RECIPIENT=UKRDC
```

In addition you will need to remove the ukrdc_keyring.gpg file so it is re-created when the next
UKRDC export runs.

In order to gpg encrypt files we need to import this public key into a keyring, and then use
the recipient name related to that public key (eg 'UKRDC') so that gpg can choose the correct key.
Currently there seems to be no gpg support for encryping a message just by specifying a public key
file, so we create a gpg keyring file at runtime if one does not yet exist on disk.
If you want to switch to a different public key you can delete ukrdc_keyring.gpg file.


For reference, the code to re-create the keyring is

```
gpg --import --no-default-keyring --keyring ./ukrdc_keyring.gpg  ./public_keys/ukrdc.asc
```

You can list the keys in the keyring to check there is one for the recipient 'UKRDC':

```
gpg --keyring ./ukrdc_keyring.gpg --list-keys
```
