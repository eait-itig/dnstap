CREATE TABLE dnstapstats
(
    `begin_at` DateTime64(3) CODEC(DoubleDelta),
    `end_at` DateTime64(3) CODEC(DoubleDelta),
    `user_ms` UInt32 CODEC(Gorilla),
    `kern_ms` UInt32 CODEC(Gorilla),
    `reads` UInt64 CODEC(Gorilla),
    `packets` UInt64 CODEC(Gorilla),
    `bytes` UInt64 CODEC(Gorilla),
    `lookups` UInt32 CODEC(Gorilla),
    `rdns` UInt32 CODEC(Gorilla),
    `pcap_recv` UInt32 CODEC(Gorilla),
    `pcap_drop` UInt32 CODEC(Gorilla),
    `pcap_ifdrop` UInt32 CODEC(Gorilla),
    `mdrop` UInt64 CODEC(Gorilla),
    INDEX begin_at_idx begin_at TYPE minmax GRANULARITY 2048,
    INDEX end_at_idx end_at TYPE minmax GRANULARITY 2048
)
ENGINE = SummingMergeTree()
PARTITION BY toStartOfDay(begin_at)
ORDER BY (begin_at, end_at)
TTL toDateTime(end_at) + toIntervalDay(60);

CREATE TABLE dns_lookups
(
    `begin_at` DateTime64(3) CODEC(DoubleDelta),
    `end_at` DateTime64(3) CODEC(DoubleDelta),
    `saddr` FixedString(16) CODEC(ZSTD(1)),
    `daddr` FixedString(16) CODEC(ZSTD(1)),
    `sport` UInt16 CODEC(Gorilla),
    `dport` UInt16 CODEC(Gorilla),
    `qid` UInt16 CODEC(Gorilla),
    `name` String CODEC(ZSTD(1)),
    INDEX begin_at_idx begin_at TYPE minmax GRANULARITY 1024,
    INDEX end_at_idx end_at TYPE minmax GRANULARITY 1024
)
ENGINE = MergeTree()
PARTITION BY toStartOfDay(begin_at)
ORDER BY (saddr, daddr, sport, dport, qid, begin_at, end_at);

CREATE TABLE rdns
(
    `begin_at` DateTime64(3) CODEC(DoubleDelta),
    `end_at` DateTime64(3) CODEC(DoubleDelta),
    `addr` FixedString(16) CODEC(ZSTD(1)),
    `name` String CODEC(ZSTD(1)),
    INDEX end_at_idx end_at TYPE minmax GRANULARITY 1024,
    INDEX begin_at_idx begin_at TYPE minmax GRANULARITY 1024
)
ENGINE = MergeTree()
PARTITION BY toStartOfDay(end_at)
ORDER BY (addr, end_at, begin_at);

