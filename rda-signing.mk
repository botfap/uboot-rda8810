#
# RDA-SIGNING rules
#
# Vendor secure boot configuration
sinclude $(VENDORKEYDIR)/cryptoconf.mk

ifdef VENDOR_SECRET_KEY
RDASIGN := -sign

VENDOR_PKEY_CERT := $(realpath $(VENDORKEYDIR)/$(VENDOR_PKEY_CERT))
VENDOR_SECRET_KEY := $(realpath $(VENDORKEYDIR)/$(VENDOR_SECRET_KEY))
VENDOR_SESSION_KEY := $(realpath $(VENDORKEYDIR))/session.token
UBOOT_SIGN_FLAGS := -s $(VENDOR_SESSION_KEY)

SPL_SIGN_FLAGS := -k$(VENDOR_KEYINDEX) -v$(VENDOR_ID) $(UBOOT_SIGN_FLAGS) -t $(VENDOR_PKEY_CERT)

RDACRYPTOSESSION := $(shell uuidgen)

export RDACRYPTOSESSION SPL_SIGN_FLAGS UBOOT_SIGN_FLAGS VENDOR_SECRET_KEY
export VENDOR_PKEY_CERT VENDOR_SECRET_KEY RDASIGN

.INTERMEDIATE: $(VENDOR_SESSION_KEY)
.PHONY: $(VENDOR_SESSION_KEY)

$(VENDOR_SESSION_KEY): $(VENDOR_SECRET_KEY)
	@echo "Create temp signing token"
	rdasign -P -s $< -x $@

else
VENDOR_SESSION_KEY :=
RDASIGN :=

endif
