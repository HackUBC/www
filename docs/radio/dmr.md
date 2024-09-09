# DMR

UBC uses trunked MOTOTRBO DMR for campus security or other service ppl's handheld radio.

I'm completely new to DMR, so nothing helpful here.

Read more (from 2017): https://www.radioreference.com/db/sid/7848

To decode using dsd-fme and RTL-SDR, use `dsd-fme -ft -i rtl -T -C ./channel_map.csv -G ./group.csv -N`.

```shell
$ cat channel_map.csv group.csv 
ChannelNumber(dec),frequency(Hz) (do not delete this line or won't import properly)
1,463587500
2,461687500
3,462737500
DEC,Mode(A- Allow, B - Block, DE - Digital Enc),Name of Group,Tag (do not delete this line or won't import properly)
52,A,SEC PATROL
55,A,MUSEUM SEC
50,A,PARKING PATROL
33,A,STEAM
34,A,WATER-SEWERS
43,A,HIGHVOLT MAIN
14,A,FIREALARMS
19,A,MECH
37,A,GARBAGE
46,A,EVENT 1
```

Read dsd-fme(1) for more info.
