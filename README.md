# setdns-route53

This is a small shell script which reads from a config file and sets a list of
names in an AWS Route53 zone by name.

`setdns-route53` sets these records to the *public IP* of the machine, so it
may be useful for exposed services running on roaming machines, residential
connections without a static IP, etc.

It runs as a dedicated user, `setdns-route53`.

## Config

`setdns-route53` reads its config from `/etc/setdns-route53`. See the comments
in the base config file for details.

Basically, the file has two columns: record name and zone name. For example:

	myservice myorg.net
	myinternalservice internal.myorg.net

The tool will use the Route53 API to find the hosted zone ID of those zones,
and then set an A record to its

## Authorization

`setdns-route53` assumes that it can find environment config or an IAM role
giving it the appropriate level of access in Route53.

If there's no IAM role available (i.e. you're not running in AWS), you'll need
to set up an `AWS_PROFILE` using the usual awscli conventions, and add it to the systemd unit file. For example:

	[Service]
	Environment=AWS_PROFILE=myprofile

For IAM, the tool requires these permissions specifically for the zones it will
mutate:

* `route53:ChangeResourceRecordSets`
* `route53:GetHostedZone`
* `route53:ListResourceRecordSets`

And this permissions for all resources (`*`):

* `route53:ListHostedZones`

Here's a full example (note that `$ZONE_ID` should be substituted). In this
example, the permissions are separated into two policy statements so that
global permissions are only set for the `ListHostedZones` operation:

	{
	    "Version": "2012-10-17",
	    "Statement": [
		{
		    "Effect": "Allow",
		    "Action": [
			"route53:ChangeResourceRecordSets",
			"route53:GetHostedZone",
			"route53:ListResourceRecordSets"
		    ],
		    "Resource": [
			"arn:aws:route53:::hostedzone/$ZONE_ID"
		    ]
		},
		{
		    "Effect": "Allow",
		    "Action": [
			"route53:ListHostedZones"
		    ],
		    "Resource": [
			"*"
		    ]
		}
	    ]
	}

## Packaging

Install `debhelper` and then run:

	dpkg-buildpackage -us -uc -b

The resulting `.deb` artifact can be distributed or installed directly with
`dpkg -i`.
