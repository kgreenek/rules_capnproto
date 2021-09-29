@0x8474f9c1e7b23df5;

using import "/cc_example/capnp/person.capnp".Person;

using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("cc_example::capnp");

struct AddressBook {
  people @0 :List(Person);
}
