# Tensor Pooling Tracker

MATLAB implementation of the tracking method described in the paper [Tensor Pooling for Online Visual Tracking](https://www.computer.org/csdl/proceedings/icme/2015/7082/00/07177452-abs.html).

## Running the tracker

Run tracking on single video "Subway" (which is already included in this repository):

```
>> demo_single_tracker
```

Run tracking on full benchmark:

1) Change `base_path` in "config.m" to your path to the [benchmark dataset](http://cvlab.hanyang.ac.kr/tracker_benchmark/index.html).
2) Run `demo_benchmark`.

All tracking results will be stored in the "results" folder.

## References

If you find this work useful, please consider citing:

↓ [Conference paper] ↓
```
@inproceedings{Huang2015Tensor,
  title={Tensor pooling for online visual tracking},
  author={Huang, Lianghua and Ma, Bo},
  booktitle={IEEE International Conference on Multimedia and Expo},
  pages={1-6},
  year={2015},
}
```
↓ [Journal paper] ↓
```
@article{Ma2017Discriminative,
  title={Discriminative Tracking Using Tensor Pooling.},
  author={Ma, B. and Huang, L. and Shen, J. and Shao, L.},
  journal={IEEE Transactions on Cybernetics},
  volume={46},
  number={11},
  pages={2411-2422},
  year={2017},
}
```

## License

This code can be freely used for personal, academic, or educational purposes.

Please contact us for commercial use.
